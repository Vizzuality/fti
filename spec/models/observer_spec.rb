# == Schema Information
#
# Table name: observers
#
#  id            :integer          not null, primary key
#  observer_type :string           not null
#  country_id    :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Observer, type: :model do
  before :each do
    FactoryGirl.create(:observer, name: 'Z Observer')
    @observer = create(:observer)
  end

  it 'Count on observer' do
    expect(Observer.count).to          eq(2)
    expect(Observer.all.first.name).to eq('Z Observer')
  end

  it 'Order by name asc' do
    expect(Observer.by_name_asc.first.name).to eq('Observer')
  end

  it 'Fallbacks for empty translations on observer' do
    I18n.locale = :fr
    expect(@observer.name).to eq('Observer')
    I18n.locale = :en
  end

  it 'Translate observer to fr' do
    @observer.update(name: 'Observer FR', locale: :fr)
    I18n.locale = :fr
    expect(@observer.name).to eq('Observer FR')
    I18n.locale = :en
    expect(@observer.name).to eq('Observer')
  end

  it 'Name and observer_type validation' do
    @observer = Observer.new(name: '', observer_type: '')

    @observer.valid?
    expect { @observer.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank, Observer type can't be blank, Observer type  is not a valid observer type")
  end

  it 'Observer_type validation' do
    @observer = Observer.new(name: 'Observer new', observer_type: 'Not in types')

    @observer.valid?
    expect { @observer.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Observer type Not in types is not a valid observer type")
  end
end