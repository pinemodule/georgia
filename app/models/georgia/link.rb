module Georgia
  class Link < ActiveRecord::Base

    include Concerns::Contentable

    belongs_to :menu, class_name: Georgia::Menu, touch: true

    acts_as_list scope: :menu
    has_ancestry orphan_strategy: :adopt
    attr_accessible :parent_id, :menu_id if needs_attr_accessible?

    scope :ordered, order('position ASC')

    before_validation :ensure_forward_slash, on: :create

    def ensure_forward_slash
      self.contents.each do |content|
        content.text.insert(0, '/') unless content.text =~ Regexp.new('(^/)|(^http)')
      end
    end

    # returns only the last part of the url
    def slug
      return '' if text.nil?
      @slug ||= text.match(/([\w-]*)$/)[0]
    end
  end
end