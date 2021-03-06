require 'active_support/concern'

module Georgia
  module Indexer
    module TireAdapter
      module GeorgiaPageExtension

        extend ActiveSupport::Concern

        included do

          include ::Tire::Model::Search
          include ::Tire::Model::Callbacks

          def to_indexed_json
            keywords = current_revision.present? ? current_revision.contents.map(&:keyword_list).flatten.uniq.join(', ') : ""
            tags = tag_list.join(', ')
            class_name = self.class.name

            indexed_hash = {
              title: title,
              text: text,
              excerpt: excerpt,
              keywords: keywords,
              url: url,
              template: template,
              tags: tags,
              tag_list: tag_list,
              publish_state: publish_state,
              class_name: class_name,
              updated_at: updated_at.strftime('%F'),
              revision_id: revision_id
            }
            indexed_hash.to_json
          end

          def self.search_index params
            search(page: (params[:page] || 1), per_page: (params[:per] || 25)) do
              if params[:query].present?
                query do
                  boolean do
                    must { string params[:query], default_operator: "AND" }
                  end
                end
                sort { by (params[:o] || :updated_at), (params[:dir] || :desc) }
              end
            end
          end

        end

      end
    end
  end
end