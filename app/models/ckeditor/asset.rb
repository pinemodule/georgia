class Ckeditor::Asset < ActiveRecord::Base

  include Georgia::Indexer::Adapter

  # to allow media_path in to_jq_upload
  include Georgia::Engine.routes.url_helpers

  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Georgia::Concerns::Taggable

  delegate :url, :current_path, :content_type, to: :data

  mount_uploader :data, Ckeditor::AttachmentFileUploader, mount_on: :data_file_name

  validates :data, presence: true
  attr_accessible :data if needs_attr_accessible?

  paginates_per 15

  scope :latest, order('created_at DESC')

  def to_jq_upload
    {
      "name" => read_attribute(:data),
      "size" => data.size,
      "url" => data.url,
      "delete_url" => media_path(id: id),
      "delete_type" => "DELETE"
    }
  end

  def short_name
    @short_name ||= self.data.file.filename.dup.gsub(/(.*)\.#{extension}/, '\1') if data.file and data.file.filename
  end

  def extension
    self.data_content_type ||= self.data.file.content_type
    @extension ||= data_content_type.gsub(/.*\/(.*)/, '\1')
  end

  SIZE_RANGE = {
    '< 25 KB' => 0..25,
    '25 KB to 100 KB' => 25..100,
    '100 KB to 500 KB' => 100..500,
    '500 KB to 1 MB' => 500..1000,
    '> 1 MB' => 1000..999999
  }

end