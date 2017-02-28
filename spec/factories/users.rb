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
#  username               :string
#  name                   :string
#  institution            :string
#  active                 :boolean          default(TRUE)
#  web_url                :string
#  deactivated_at         :datetime
#  permissions_request    :integer
#  permissions_accepted   :datetime
#  country_id             :integer
#

FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "pepe#{n}@vizzuality.com" }
    sequence(:username) { |n| "pepe#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Test user'
  end

  factory :ngo, class: User do
    sequence(:email)    { |n| "ngo#{n}@vizzuality.com" }
    sequence(:username) { |n| "ngo#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Test ngo'

    after(:create) do |random_ngo|
      random_ngo.user_permission.update(user_role: 'ngo')
    end
  end

  factory :admin, class: User do
    sequence(:email)    { |n| "admin#{n}@vizzuality.com" }
    sequence(:username) { |n| "admin#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Admin user'

    after(:create) do |random_admin|
      random_admin.user_permission.update(user_role: 'admin')
    end
  end
end
