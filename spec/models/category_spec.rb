# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  before :each do
    Country.delete_all
    I18n.locale = :en
    FactoryGirl.create(:category, name: 'Z Category')
    @category = create(:category)
  end

  it 'Count on category' do
    expect(Category.count).to          eq(2)
    expect(Category.all.first.name).to eq('Z Category')
  end

  it 'Order by name asc' do
    expect(Category.by_name_asc.first.name).to eq('A Category')
  end

  it 'Fallbacks for empty translations on category' do
    I18n.locale = :fr
    expect(@category.name).to eq('A Category')
    I18n.locale = :en
  end

  it 'Translate category to fr' do
    @category.update(name: 'Category FR', locale: :fr)
    I18n.locale = :fr
    expect(@category.name).to eq('Category FR')
    I18n.locale = :en
    expect(@category.name).to eq('A Category')
  end

  it 'Common and scientific name validation' do
    @category = Category.new(name: '')

    @category.valid?
    expect { @category.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end
end
