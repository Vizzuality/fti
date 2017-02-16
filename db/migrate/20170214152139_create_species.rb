# frozen_string_literal: true
class CreateSpecies < ActiveRecord::Migration[5.0]
  def change
    create_table :species do |t|
      t.integer :iucn_status,  index: true
      t.integer :cites_status, index: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Species.create_translation_table!({
          common_name: :string,
          scientific_name: :string
        })
      end

      dir.down do
        Species.drop_translation_table!
      end
    end
  end
end
