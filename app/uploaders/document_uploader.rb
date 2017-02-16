# frozen_string_literal: true
class DocumentUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def extension_whitelist
    %w(pdf doc docx xls xlsx txt xml csv)
  end

  def content_type_whitelist
    /document\//
  end
end
