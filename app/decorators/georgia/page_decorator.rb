module Georgia
  class PageDecorator < ApplicationDecorator
    decorates :page, class: Georgia::Page
    decorates_association :children, with: Georgia::PageDecorator

    PUBLISHED = 'Published'
    PENDING = 'Pending'
    UNDER_REVIEW = 'Waiting for Review'
    NOT_TRANSLATED = 'Missing Translation'
    SEO_INCOMPLETE = 'SEO Incomplete'

    def title
      content.title
    end

    def text
      h.truncate(h.strip_tags(content.text), length: 100)
    end

    def url
      if is_root?
        "/#{slug}"
      else
        "/#{ancestors.map(&:slug).join('/')}/slug"
      end
    end

    def slug_tag
      h.content_tag :span, parent.present? ? "/#{parent.slug}/#{model.slug}" : model.slug, class: 'light'
    end

    def status_tag
      h.content_tag(:span, class: "label label-#{status.try(:label)}") do
        h.raw(h.icon_tag("icon-white #{status.try(:icon)}") + ' ' + status.try(:name))
      end
    end

  end
end