# == Schema Information
#
# Table name: governments
#
#  id         :integer          not null, primary key
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :government do
    name              'A Government'
    government_entity 'Lorem ipsum..'
    details           'Indicator one'

    after(:create) do |government|
      government.update(country: FactoryGirl.create(:country))
    end
  end
end
