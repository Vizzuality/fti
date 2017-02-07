require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  before :each do
    @user  = create(:user)
    @admin = create(:admin)
  end

  it { Ability.should include(CanCan::Ability)          }
  it { Ability.should respond_to(:new).with(1).argument }

  describe 'Ability' do
    context 'When is a user' do
      it 'Can manage owned profile' do
        Ability.any_instance.should_receive(:can).with([:read], :all)
        Ability.any_instance.should_receive(:can).with([:manage], User, id: @user.id)
        Ability.any_instance.should_receive(:can).with([:manage], UserPermission, user_id: @user.id)
        Ability.new @user
      end
    end

    context 'When is an admin' do
      it 'Can manage all' do
        Ability.any_instance.should_receive(:can).with([:read], :admin)
        Ability.any_instance.should_receive(:can).with([:manage], :all)
        Ability.new @admin
      end
    end
  end
end
