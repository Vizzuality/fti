require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  before :each do
    @user  = create(:user)
    @admin = create(:admin)
  end

  it { expect(Ability).to include(CanCan::Ability)          }
  it { expect(Ability).to respond_to(:new).with(1).argument }

  describe 'Ability' do
    context 'When is a user' do
      it 'Can manage owned profile' do
        expect_any_instance_of(Ability).to receive(:can).with([:read], :all)
        expect_any_instance_of(Ability).to receive(:can).with([:manage], User, id: @user.id)
        expect_any_instance_of(Ability).to receive(:can).with([:manage], UserPermission, user_id: @user.id)
        Ability.new @user
      end
    end

    context 'When is an admin' do
      it 'Can manage all' do
        expect_any_instance_of(Ability).to receive(:can).with([:read], :admin)
        expect_any_instance_of(Ability).to receive(:can).with([:manage], :all)
        Ability.new @admin
      end
    end
  end
end
