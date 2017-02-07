# frozen_string_literal: true
module Roleable
  extend ActiveSupport::Concern

  included do
    has_one :user_permission

    after_create :set_permissions

    private

      def set_permissions
        self.create_user_permission(user_role: :user, permissions: { all: { all: [:read] }, user: { id: [:manage] }, user_permission: { user_id: [:manage] } }) unless self.user_permission.present?
      end
  end

  class_methods do
  end
end
