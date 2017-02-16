# frozen_string_literal: true
class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('' + [version_name, 'placeholder.png'].compact.join('_'))
  end

  process resize_to_fit: [1200, 1200]

  version :thumbnail do
    process resize_to_fill: [120, 120, 'Center']
  end

  version :square do
    process resize_to_fill: [600, 600, 'Center']
  end

  version :medium do
    process resize_to_fill: [600, 600]
  end
end
