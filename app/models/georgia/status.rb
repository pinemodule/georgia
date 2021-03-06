module Georgia
  class Status < ActiveRecord::Base

    PUBLISHED = 'Published'
    DRAFT = 'Draft'
    PENDING_REVIEW = 'Pending Review'

    has_many :pages

    attr_accessible :name, :label, :icon if needs_attr_accessible?

    validates :name, presence: true

    scope :published, where(name: PUBLISHED)
    scope :draft, where(name: DRAFT)
    scope :pending_review, where(name: PENDING_REVIEW)

    def published?
      self.name == PUBLISHED
    end
    def draft?
      self.name == DRAFT
    end
    def pending_review?
      self.name == PENDING_REVIEW
    end

  end
end