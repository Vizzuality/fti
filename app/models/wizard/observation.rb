# frozen_string_literal: true
module Wizard
  module Observation
    STEPS = %w(types info attachments).freeze

    class Base
      include ActiveModel::Model
      attr_accessor :observation

      delegate *::Observation.includes(:translations, :photos, :documents, :species).attribute_names.map { |attr| [attr, "#{attr}="] }.flatten, to: :observation

      def initialize(observation_attributes)
        @observation = ::Observation.new(observation_attributes)
      end
    end

    class Types < Base
      validates :country_id, presence: true
      validates :observation_type, presence: true, inclusion: { in: %w(AnnexGovernance AnnexOperator),
                                                                message: "%{value} is not a valid observation type" }
    end

    class Info < Types
    end

    class Attachments < Info
    end
  end
end
