# == Schema Information
#
# Table name: observers
#
#  id            :integer          not null, primary key
#  observer_type :string           not null
#  country_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  active        :boolean          default(TRUE)
#  logo          :string
#

FactoryGirl.define do
  factory :observer do
    name          "Observer #{Faker::Lorem.sentence}"
    observer_type 'External'
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files', 'image.png')) }
  end
end
