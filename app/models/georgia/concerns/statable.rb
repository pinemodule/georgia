require 'active_support/concern'

module Georgia
  module Concerns
    module Statable
      extend ActiveSupport::Concern

      included do

        attr_accessible :state if needs_attr_accessible?

        state_machine :state, initial: :draft do

          state :published
          state :draft
          state :review
          state :revision

          # Drafts
          event :review do
            transition all => :review
          end

          # Reviews
          event :approve do
            transition [:draft, :review] => :published
          end
          event :decline do
            transition :review => :draft
          end

          # Published
          event :store do
            transition :published => :revision
          end
          event :unpublish do
            transition :published => :draft
          end

          # Revisions
          event :restore do
            transition :revision => :published
          end

          before_transition any => :published do |revision, transition|
            revision.revisionable.approve_revision(revision)
          end

        end

        scope :published, with_states(:published)
        scope :drafts, with_states(:draft)
        scope :reviews, with_states(:review)
        scope :stored, with_states(:revision)

        def status_name
          warn "[DEPRECATION] `status_name` is deprecated.  Please use `human_state_name` instead."
          human_state_name
        end

      end

    end
  end
end