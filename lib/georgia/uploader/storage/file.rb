require 'active_support/concern'

module Georgia
  module Uploader
    module Storage
      module File
        extend ActiveSupport::Concern

        included do
          include Ckeditor::Backend::CarrierWave
          require 'carrierwave/processing/mini_magick'
          include CarrierWave::MiniMagick
          storage :file
        end

        def store_dir
          "assets/#{model.id}"
        end

      end
    end
  end
end