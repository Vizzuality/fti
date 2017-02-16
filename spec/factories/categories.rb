# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :category do
    name 'A Category'

    after(:create) do |category|
      category.update(annex_operators: [FactoryGirl.create(:annex_operator)])
    end
  end
end
