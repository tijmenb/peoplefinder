# FIXME: Refactor this controller - it's too long and mailing shouldn't be done in models
# rubocop:disable ClassLength
class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :set_org_structure,
    only: [:new, :edit, :create, :update, :add_membership]
  before_action :load_versions, only: [:show]
  before_action :check_and_set_preview_flag, only: [:create, :update]

  # GET /people
  def index
    redirect_to '/'
  end

  # GET /people/1
  def show
    authorize @person
  end

  # GET /people/new
  def new
    @person = Person.new
    authorize @person

    @person.memberships.build
    @person.build_building
    @person.build_city
  end

  # GET /people/1/edit
  def edit
    check_policy!
    authorize @person

    @activity = params[:activity]
    @person.memberships.build if @person.memberships.empty?
    @person.build_building  unless @person.building
    @person.build_city      unless @person.city
  end

  # POST /people
  def create
    @person = Person.new(person_create_params)
    check_policy!
    authorize @person

    if @preview
      render :new
    elsif @person.valid?
      confirm_or_create
    else
      error :create_error
      render :new
    end
  end

  # PATCH/PUT /people/1
  def update
    check_policy!
    @person.assign_attributes(person_update_params)
    authorize @person

    if @preview
      render :edit
    elsif @person.valid?
      confirm_or_update
    else
      render :edit
    end
  end

  # DELETE /people/1
  def destroy
    check_policy!
    authorize @person

    destroyer = PersonDestroyer.new(@person, current_user)
    destroyer.destroy!
    notice :profile_deleted, person: @person
    redirect_to home_path
  end

  def add_membership
    set_person if params[:id].present?
    @person ||= Person.new
    authorize @person

    render 'add_membership', layout: false
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.friendly.includes(:groups).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def person_create_params
    params.require(:person).permit(*person_shared_params_list)
  end

  def person_update_params
    params.require(:person).permit(*(person_shared_params_list - [:email]))
  end

  def person_shared_params_list
    [
      :given_name, :surname, :location_in_building,
      :building_id, :city_id, :custom_building, :custom_city,
      :primary_phone_number, :secondary_phone_number, :email, :secondary_email,
      :profile_photo_id, :crop_x, :crop_y, :crop_w, :crop_h,
      :description, :tags, :community_id, :staff_nr,
      *Person::DAYS_WORKED,
      memberships_attributes: [:id, :role, :group_id, :leader, :subscribed],
    ]
  end

  def set_org_structure
    @org_structure = Group.arrange.to_h
  end

  def namesakes?
    return false if params['commit'] == 'Continue'

    @people = Person.namesakes(@person)
    @people.present?
  end

  def confirm_or_create
    if namesakes?
      render(:confirm)
    else
      creator = PersonCreator.new(@person, current_user)
      creator.create!
      notice :profile_created, person: @person
      redirect_to @person
    end
  end

  def confirm_or_update
    if namesakes?
      render(:confirm)
    else
      updater = PersonUpdater.new(@person, current_user)
      updater.update!

      type = @person == current_user ? :mine : :other
      notice :profile_updated, type, person: @person
      redirect_to @person
    end
  end

  def load_versions
    if super_admin?
      @versions = AuditVersionPresenter.wrap(@person.versions)
    end
  end

  def check_and_set_preview_flag
    @preview = params[:preview].present?
  end

  def check_policy!
    unless PolicyValidator.new(@person.groups.first).validate(current_user)
      error :not_authorized_error
      redirect_to :home
    end
  end
end
