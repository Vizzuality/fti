# == Schema Information
#
# Table name: operators
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  operator_type :string
#  country_id    :integer
#  concession    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Operator, type: :model do
  before :each do
    FactoryGirl.create(:operator, name: 'Z Operator')
    @operator = create(:operator)
  end

  it 'Count on operator' do
    expect(Operator.count).to          eq(2)
    expect(Operator.all.first.name).to eq('Z Operator')
  end

  it 'Order by name asc' do
    expect(Operator.by_name_asc.first.name).to eq('Operator')
  end

  it 'Fallbacks for empty translations on operator' do
    I18n.locale = :fr
    expect(@operator.name).to eq('Operator')
    I18n.locale = :en
  end

  it 'Translate operator to fr' do
    @operator.update(name: 'Operator FR', locale: :fr)
    I18n.locale = :fr
    expect(@operator.name).to eq('Operator FR')
    I18n.locale = :en
    expect(@operator.name).to eq('Operator')
  end

  it 'Name validation' do
    @operator = Operator.new(name: '')

    @operator.valid?
    expect { @operator.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end
end
