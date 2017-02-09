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
    @user     = create(:user)
    @user_ngo = create(:user, permissions_request: 'ngo')
  end

  let!(:user_permissions) {
    {"all"=>{"all"=>["read"]}, "user"=>{"id"=>["manage"]}}
  }

  let!(:admin_permissions) {
    {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}}
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

  it 'Accept user role request' do
    @user_ngo.user_permission.update(user_role: 'ngo', permissions: user_permissions)

    expect(@user_ngo.user_permission.user_role).to   eq('ngo')
    expect(@user_ngo.user_permission.permissions).to eq(user_permissions)
  end

  it 'Is a user an user? Show the role name' do
    expect(@user.admin?).to    eq(false)
    expect(@user.user?).to     eq(true)
    expect(@user.role_name).to eq('User')
  end
end
