# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string           default(""), not null
#  name                   :string
#  institution            :string
#  active                 :boolean          default(TRUE)
#  web_url                :string
#  deactivated_at         :datetime
#

# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  attr_accessor :login

  include Activable
  include Roleable

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :name,     presence: true
  validate  :validate_username

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  scope :recent, -> { order('updated_at DESC') }

  class << self
    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
      else
        if conditions[:username].nil?
          where(conditions).first
        else
          where(username: conditions[:username]).first
        end
      end
    end
  end

  private

    def validate_username
      if User.where(email: username).exists?
        errors.add(:username, :invalid)
      end
    end
end
