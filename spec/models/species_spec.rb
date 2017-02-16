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

require 'rails_helper'

RSpec.describe Species, type: :model do
  before :each do
    FactoryGirl.create(:species, common_name: 'Z Species')
    @species = create(:species)
  end

  it 'Count on species' do
    expect(Species.count).to                 eq(2)
    expect(Species.all.first.common_name).to eq('Z Species')
  end

  it 'Order by common_name asc' do
    expect(Species.by_common_name_asc.first.common_name).to eq('Species')
  end

  it 'Fallbacks for empty translations on species' do
    I18n.locale = :fr
    expect(@species.common_name).to eq('Species')
    I18n.locale = :en
  end

  it 'Translate species to fr' do
    @species.update(common_name: 'Species FR', locale: :fr)
    I18n.locale = :fr
    expect(@species.common_name).to eq('Species FR')
    I18n.locale = :en
    expect(@species.common_name).to eq('Species')
  end

  it 'Common and scientific name validation' do
    @species = Species.new(common_name: '', scientific_name: '')

    @species.valid?
    expect { @species.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Common name can't be blank, Scientific name can't be blank")
  end
end
