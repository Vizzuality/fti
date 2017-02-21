require 'csv'

namespace :import_species_csv do
  I18n.locale = :en
  desc 'Loads species data from a csv file'
  task create_species: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'cites_listings.csv'))
    puts '* Loading Species... *'
    Species.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        country_names = data_row['countries'].split(',') if data_row['countries'].present?
        country_ids   = Country.where(name: country_names).pluck(:id) if country_names.present?

        data_species = {}
        data_species[:cites_id]        = data_row['cites_id']
        data_species[:species_kingdom] = data_row['species_kingdom']
        data_species[:species_class]   = data_row['species_class']
        data_species[:species_family]  = data_row['species_family']
        data_species[:name]            = data_row['name']
        data_species[:sub_species]     = data_row['sub_species']
        data_species[:scientific_name] = data_row['scientific_name']
        data_species[:cites_status]    = data_row['cites_status']
        data_species[:country_ids]     = country_ids if country_ids.present?

        Species.create!(data_species) if data_row['name'].present?
      end
    end
    puts 'Species loaded'
  end
end

namespace :import_monitors_csv do
  I18n.locale = :en
  desc 'Loads monitors data from a csv file'
  task create_monitors: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'monitors.csv'))
    puts '* Loading Monitors... *'
    Observer.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        Observer.find_or_create_by!(data_row)
      end
    end
    puts 'Monitors loaded'
  end
end

namespace :import_operators_csv do
  I18n.locale = :en
  desc 'Loads operators data from a csv file'
  task create_operators: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'operators.csv'))
    puts '* Loading Operators... *'
    Operator.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        Operator.find_or_create_by!(data_row)
      end
    end
    puts 'Operators loaded'
  end
end

namespace :import_categories_csv do
  I18n.locale = :en
  desc 'Loads categories data from a csv file'
  task create_categories: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'categories.csv'))
    puts '* Loading Categories... *'
    Category.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        Category.find_or_create_by!(data_row)
      end
    end
    puts 'Categories loaded'
  end
end

namespace :import_laws_csv do
  I18n.locale = :en
  desc 'Loads laws data from a csv file'
  task create_laws: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'laws.csv'))
    puts '* Loading Laws... *'
    Law.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        Law.find_or_create_by!(data_row) if data_row['legal_reference'].present?
      end
    end
    puts 'Laws loaded'
  end
end

namespace :import_annex_operators_csv do
  I18n.locale = :en
  desc 'Loads annex operators data from a csv file'
  task create_annex_operators: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'annex_operators.csv'))
    AnnexOperator.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        country_names = data_row['countries'].split(',') if data_row['countries'].present?
        country_ids   = Country.where(name: country_names).pluck(:id)

        category_names = data_row['category_name'].split(',') if data_row['category_name'].present?
        category_ids   = Category.where(name: category_names).pluck(:id)

        data_ao = {}
        data_ao[:illegality]   = data_row['illegality']

        country_ids.each do |country_id|
          data_ao[:country_id] = country_id

          @ao = AnnexOperator.find_or_create_by!(data_ao)
          @ao.update!(illegality: data_row['illegality_fr'],
                      categorings_attributes: [{ category_id: category_ids.first, categorizable: @ao }],
                      severities_attributes: [{ level: 3, details: data_row['severity_3'] || 'Not specified' },
                                              { level: 2, details: data_row['severity_2'] || 'Not specified' },
                                              { level: 1, details: data_row['severity_1'] || 'Not specified' },
                                              { level: 0, details: data_row['severity_0'] || 'Not specified' }], locale: :fr)
        end
      end
    end
    puts 'Annex operators loaded'
  end
end

namespace :import_operator_observations_csv do
  I18n.locale = :en
  desc 'Loads operator observations data from a csv file'
  task create_operator_observation: :environment do
    filename = File.expand_path(File.join(Rails.root, 'db', 'files', 'operator_observations.csv'))
    Observation.transaction do
      CSV.foreach(filename, col_sep: ';', row_sep: :auto, headers: true, encoding: 'UTF-8') do |row|
        data_row = row.to_h

        category_names = data_row['category_name'].split(',') if data_row['category_name'].present?
        category_ids   = Category.where(name: category_names).pluck(:id)

        monitor_name = data_row['monitor_name']
        monitor_id   = Observer.where(name: monitor_name).pluck(:id) if monitor_name.present?

        operator_name = data_row['operator_name']
        operator_id   = Operator.where(name: operator_name).pluck(:id) if operator_name.present?

        law_names = data_row['legal_reference'].split(',') if data_row['legal_reference'].present?
        law_id    = Law.where(legal_reference: law_names).pluck(:id)

        data_oo = {}
        data_oo[:observation_type]  = 'AnnexOperator'
        data_oo[:publication_date]  = data_row['publication_date']
        data_oo[:country_id]        = data_row['country_id']
        data_oo[:details]           = data_row['description']
        data_oo[:evidence]          = data_row['evidence']
        data_oo[:operator_opinion]  = data_row['operator_opinion']
        data_oo[:litigation_status] = data_row['litigation_status']
        data_oo[:pv]                = data_row['pv']
        data_oo[:observer_id]       = monitor_id.first  if monitor_id.present?
        data_oo[:operator_id]       = operator_id.first if operator_id.present?

        @oo = Observation.find_or_create_by!(data_oo)

        data_ao = {}
        data_ao[:illegality]   = data_row['illegality']
        data_ao[:law_id]       = law_id.first if law_id.present?

        if @ao = AnnexOperator.find_by(illegality: data_row['illegality'])
          @ao
        else
          @ao = AnnexOperator.find_or_create_by!(data_ao)
          @ao.update!(law_id: law_id,
                      categorings_attributes: [{ category_id: category_ids.first, categorizable: @ao }],
                      severities_attributes: [{ level: 3, details: 'Not specified' },
                                              { level: 2, details: 'Not specified' },
                                              { level: 1, details: 'Not specified' },
                                              { level: 0, details: 'Not specified' }])
        end

        severity_id = @ao.severities.where(level: data_row['severities']).first.id

        @oo.update!(annex_operator_id: @ao.id, severity_id: severity_id)
      end
    end
    puts 'Operator observations loaded'
  end
end
