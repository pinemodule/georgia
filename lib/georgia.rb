require "georgia/paths"
require "georgia/engine"
require "georgia/assets"

module Georgia

  mattr_accessor :templates
  @@templates = %w(default one-column sidebar-left sidebar-right)

  mattr_accessor :title
  @@title = "Georgia"

  mattr_accessor :url
  @@url = "http://www.example.com"

  mattr_accessor :header
  @@header = %w(pages menus messages media)

  def self.setup
    yield self
  end

end