require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { should validate_presence_of(:person).on(:update) }
  it { should validate_presence_of(:group).on(:update) }

  subject { described_class.new }

  it 'is not a leader by default' do
    is_expected.not_to be_leader
  end

  it 'is suscribed by default' do
    is_expected.to be_subscribed
  end
end
