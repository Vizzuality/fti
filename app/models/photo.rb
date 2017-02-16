# frozen_string_literal: true
# == Schema Information
#
# Table name: photos
#
#  id               :integer          not null, primary key
#  name             :string
#  attachment       :string
#  attacheable_id   :integer
#  attacheable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Photo < ApplicationRecord
  mount_uploader :photo,    PhotoUploader

  belongs_to :attacheable, polymorphic: true
end
