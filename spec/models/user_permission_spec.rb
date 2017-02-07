# == Schema Information
#
# Table name: user_permissions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  user_role   :integer          default("user"), not null
#  permissions :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe UserPermission, type: :model do
  before :each do
    @user = create(:user)
  end

  let!(:user_permissions) {
    {"all"=>{"all"=>["read"]}, "user"=>{"id"=>["manage"]}, "user_permission"=>{"user_id"=>["manage"]}}
  }

  let!(:admin_permissions) {
    {"all"=>{"all"=>["manage"]}, "user"=>{"id"=>["manage"]}, "user_permission"=>{"user_id"=>["manage"]}}
  }

  it 'Check default user permissions' do
    expect(@user.user_permission.user_role).to   eq('user')
    expect(@user.user_permission.permissions).to eq(user_permissions)
  end

  it 'Change user permissions and role' do
    @user.user_permission.update(user_role: 'admin', permissions: admin_permissions)

    expect(@user.user_permission.user_role).to   eq('admin')
    expect(@user.user_permission.permissions).to eq(admin_permissions)
  end
end
