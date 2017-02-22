# == Schema Information
#
# Table name: severities
#
#  id             :integer          not null, primary key
#  level          :integer
#  severable_id   :integer          not null
#  severable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Severity, type: :model do
  before :each do
    I18n.locale = :en
    @annex = create(:annex_governance)
    FactoryGirl.create(:severity, severable: @annex, level: 2)
    @severity = create(:severity, severable: @annex)
  end

  it 'Count on severity' do
    expect(Severity.count).to           eq(2)
    expect(Severity.all.first.level).to eq(2)
  end

  it 'Order by level asc' do
    expect(Severity.by_level_asc.first.level).to eq(1)
  end

  it 'Access severable information' do
    expect(@severity.severable.governance_pillar).to eq('Annex governance pillar')
    expect(@annex.severities.size).to               eq(2)
  end

  it 'Fallbacks for empty translations on severity' do
    I18n.locale = :fr
    expect(@severity.details).to eq('Lorem ipsum..')
    I18n.locale = :en
  end

  it 'Translate severity to fr' do
    I18n.locale = :en
    @severity.update(details: 'Lorem ipsum.. FR', locale: :fr)
    I18n.locale = :fr
    expect(@severity.details).to eq('Lorem ipsum.. FR')
    I18n.locale = :en
    expect(@severity.details).to eq('Lorem ipsum..')
  end

  it 'Level and details validation' do
    @severity = Severity.new(level: '', details: '')

    @severity.valid?
    expect { @severity.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Details can't be blank, Level can't be blank")
  end
end
