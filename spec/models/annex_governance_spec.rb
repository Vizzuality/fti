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
      FactoryGirl.create(:annex_governance, government_entity: 'Z Annex governance pilar')
      @annex = create(:annex_governance)
    end

    it 'Count on annex' do
      expect(AnnexGovernance.count).to                      eq(2)
      expect(AnnexGovernance.all.first.government_entity).to eq('Z Annex governance pilar')
    end

    it 'Order by government_entity asc' do
      expect(AnnexGovernance.by_government_entity_asc.first.government_entity).to eq('Annex governance pilar')
    end

    it 'Fallbacks for empty translations on annex' do
      I18n.locale = :fr
      expect(@annex.government_entity).to eq('Annex governance pilar')
      I18n.locale = :en
    end

    it 'Translate annex to fr' do
      @annex.update(government_entity: 'Annex governance pilar FR', locale: :fr)
      I18n.locale = :fr
      expect(@annex.government_entity).to eq('Annex governance pilar FR')
      I18n.locale = :en
      expect(@annex.government_entity).to eq('Annex governance pilar')
    end
  end
end
