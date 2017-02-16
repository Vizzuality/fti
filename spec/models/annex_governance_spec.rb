# == Schema Information
#
# Table name: annex_governances
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AnnexGovernance, type: :model do
  context 'Annex governance' do
    before :each do
      FactoryGirl.create(:annex_governance, governance_pilar: 'Z Annex governance pilar')
      @annex = create(:annex_governance)
    end

    it 'Count on annex' do
      expect(AnnexGovernance.count).to                      eq(2)
      expect(AnnexGovernance.all.first.governance_pilar).to eq('Z Annex governance pilar')
    end

    it 'Order by governance_pilar asc' do
      expect(AnnexGovernance.by_governance_pilar_asc.first.governance_pilar).to eq('Annex governance pilar')
    end

    it 'Fallbacks for empty translations on annex' do
      I18n.locale = :fr
      expect(@annex.governance_pilar).to eq('Annex governance pilar')
      I18n.locale = :en
    end

    it 'Translate annex to fr' do
      @annex.update(governance_pilar: 'Annex governance pilar FR', locale: :fr)
      I18n.locale = :fr
      expect(@annex.governance_pilar).to eq('Annex governance pilar FR')
      I18n.locale = :en
      expect(@annex.governance_pilar).to eq('Annex governance pilar')
    end
  end
end
