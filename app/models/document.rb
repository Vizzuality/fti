# frozen_string_literal: true
# == Schema Information
#
# Table name: documents
#
#  id               :integer          not null, primary key
#  name             :string
#  attachment       :string
#  attacheable_id   :integer
#  attacheable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Document < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :attacheable, polymorphic: true
end
