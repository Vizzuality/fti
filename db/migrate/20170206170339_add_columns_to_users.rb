# frozen_string_literal: true
class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username,       :string,  unique: true
    add_column :users, :name,           :string
    add_column :users, :institution,    :string
    add_column :users, :active,         :boolean, default: true
    add_column :users, :web_url,        :string
    add_column :users, :deactivated_at, :datetime
  end
end
