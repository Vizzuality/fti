# == Schema Information
#
# Table name: operators
#
#  id            :integer          not null, primary key
#  operator_type :string
#  country_id    :integer
#  concession    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :operator do
    name "Operator #{Faker::Lorem.sentence}"

    after(:create) do |operator|
      operator.update(country: FactoryGirl.create(:country, name: "Country #{Faker::Lorem.sentence}",
                                                            iso: "C#{Faker::Lorem.sentence}"))
    end
  end
end
