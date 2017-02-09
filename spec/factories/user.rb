FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "pepe#{n}@vizzuality.com" }
    sequence(:username) { |n| "pepe#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Test user'
  end

  factory :admin, class: User do
    sequence(:email) { |n| "admin#{n}@vizzuality.com" }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Admin user'
    username 'admin'

    after(:create) do |random_admin|
      random_admin.user_permission.update(user_role: 'admin', permissions: { admin: { all: [:read] }, all: { all: [:manage] }})
    end
  end
end
