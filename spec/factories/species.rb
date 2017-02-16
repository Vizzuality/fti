# == Schema Information
#
# Table name: species
#
#  id           :integer          not null, primary key
#  iucn_status  :integer
#  cites_status :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :species do
    common_name     'Species'
    scientific_name 'Spezie'
  end
end
