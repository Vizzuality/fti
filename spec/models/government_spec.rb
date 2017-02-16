# == Schema Information
#
# Table name: governments
#
#  id         :integer          not null, primary key
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Government, type: :model do
  before :each do
    FactoryGirl.create(:government, name: 'Z Government')
    @government = create(:government)
  end

  it 'Count on government' do
    expect(Government.count).to          eq(2)
    expect(Government.all.first.name).to eq('Z Government')
    expect(@government.country.name).to  match('Country')
  end

  it 'Order by name asc' do
    expect(Government.by_name_asc.first.name).to eq('A Government')
  end

  it 'Fallbacks for empty translations on government' do
    I18n.locale = :fr
    expect(@government.name).to eq('A Government')
    I18n.locale = :en
  end

  it 'Translate government to fr' do
    @government.update(name: 'A Government FR', locale: :fr)
    I18n.locale = :fr
    expect(@government.name).to eq('A Government FR')
    I18n.locale = :en
    expect(@government.name).to eq('A Government')
  end
end
