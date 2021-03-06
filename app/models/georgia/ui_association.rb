module Georgia
  class UiAssociation < ActiveRecord::Base

    include Georgia::Concerns::Orderable
    acts_as_list scope: :page

    belongs_to :revision, class_name: Georgia::Revision, foreign_key: :page_id
    belongs_to :widget
    belongs_to :ui_section

    attr_accessible :position, :widget_id, :ui_section_id, :page_id if needs_attr_accessible?

    scope :for_revision, lambda {|revision| where(page_id: revision.id)}

    validate :associations

    protected

    # Validations
    def associations
      errors.add(:base, "An association to a page is required.") unless page_id.present?
      errors.add(:base, "An association to a UI Section is required.") unless ui_section_id.present?
      errors.add(:base, "An association to a Widget is required.") unless widget_id.present?
    end

  end
end