# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string           default(""), not null
#  name                   :string
#  institution            :string
#  active                 :boolean          default(TRUE)
#  web_url                :string
#  deactivated_at         :datetime
#  permissions_request    :integer
#  permissions_accepted   :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @user = create(:user, username: 'testuser')
  end

  it 'Users count' do
    expect(User.count).to eq(1)
  end

  it 'Deactivate activate user' do
    @user.deactivate
    expect(User.count).to eq(1)
    expect(User.filter_inactives.count).to eq(1)
    expect(@user.deactivated?).to be(true)
    @user.activate
    expect(@user.activated?).to be(true)
    expect(User.filter_actives.count).to be(1)
  end

  it 'User name and username validation' do
    @user = User.new(name: '', username: '', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Username can't be blank, Name can't be blank")
  end

  it 'Username is email validation' do
    @user = User.new(name: 'Test user', username: 'user@example.com', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Username is invalid')
  end

  it 'Username specific validation' do
    @user = User.new(name: 'Test user', username: 'admin 333', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Username is invalid')
  end

  it 'Username uniqueness validation' do
    @user = User.new(name: 'Test user', username: 'Testuser', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Username has already been taken')
  end
end
