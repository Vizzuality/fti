# frozen_string_literal: true
class AddActiveToOperatorsAndObservers < ActiveRecord::Migration[5.0]
  def change
    add_column :operators, :active, :boolean, default: true
    add_column :observers, :active, :boolean, default: true
  end
end
