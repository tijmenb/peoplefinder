require 'rails_helper'

RSpec.describe PolicyValidator, type: :service do
  include PermittedDomainHelper

  let(:policy) { create :policy }
  let(:restricted_group) { create :group, policy: policy }
  let(:subject) { described_class.new(restricted_group) }

  describe '#validate' do

    context 'when a Super Admin' do
      let(:user) { create(:super_admin) }

      it { expect(subject.validate(user)).to be }
    end

    context 'when regular user' do
      let(:policy) { create :policy, allowed_to: ['restrict_policy_user@cabinetoffice.gov.uk'] }

      context 'doesnt belong to the policy' do
        let(:user) { create(:person) }

        it { expect(subject.validate(user)).not_to be }
      end

      context 'belongs to the policy' do
        let(:user) { create(:person, email: 'restrict_policy_user@cabinetoffice.gov.uk') }

        it { expect(subject.validate(user)).to be }
      end

      context 'when the team is a sub-team of a restricted team policy' do
        let(:restricted_group) { create(:department, policy: policy) }
        let(:team) { create(:group, parent: restricted_group, name: 'Corporate Services') }
        let(:subject) { described_class.new(team) }

        context 'doesnt belong to the policy' do
          let(:user) { create(:person) }

          it '#validate' do
            expect(subject.validate(user)).not_to be
          end
        end

        context 'belongs to the policy' do
          let(:user) { create(:person, email: 'restrict_policy_user@cabinetoffice.gov.uk') }

          it '#validate' do
            expect(subject.validate(user)).to be
          end
        end
      end

    end # validate
  end # regular user

end
