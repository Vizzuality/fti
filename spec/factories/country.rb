FactoryGirl.define do
  factory :country do
    name        'Australia'
    region_name 'Australia/New Zealand'
    iso         'AUS'
    region_iso  'AZ'
    country_centroid '{ "type":"Point", "coordinates":[-25,135] }'
    region_centroid  '{ "type":"Point", "coordinates":[-26.3793465342288,135.977532183695] } }'
  end
end
