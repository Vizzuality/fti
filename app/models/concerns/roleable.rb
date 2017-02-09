# frozen_string_literal: true
module Roleable
  extend ActiveSupport::Concern

  included do
    has_one :user_permission

    after_create :set_permissions, if: '!self.user_permission'

    def admin?
      user_permission.user_role.in?('admin')
    end

    def user?
      user_permission.user_role.in?('user')
    end

    def role_name
      case user_permission.user_role
      when 'admin' then 'Admin'
      else
        'User'
      end
    end

    private

      def set_permissions
        self.create_user_permission(user_role: :user, permissions: { all: { all: [:read] }, user: { id: [:manage] } })
      end
  end

  class_methods do
  end
end
