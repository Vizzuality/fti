require 'csv'

namespace :import_species_csv do
  desc 'Loads species data from a csv file'
  task create_species: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'cites_listings.csv'))
    puts '* Loading Species... *'
    Species.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        country_names = data_row['countries'].split(',') if data_row['countries'].present?
        country_ids   = Country.where(name: country_names).pluck(:id)

        data_species = {}
        data_species[:cites_id]        = data_row['cites_id']
        data_species[:species_kingdom] = data_row['species_kingdom']
        data_species[:species_class]   = data_row['species_class']
        data_species[:species_family]  = data_row['species_family']
        data_species[:name]            = data_row['name']
        data_species[:sub_species]     = data_row['sub_species']
        data_species[:scientific_name] = data_row['scientific_name']
        data_species[:cites_status]    = data_row['cites_status']
        data_species[:country_ids]     = country_ids

        Species.create!(data_species) if data_row['name'].present?
      end
    end
    puts 'Species loaded'
  end
end
