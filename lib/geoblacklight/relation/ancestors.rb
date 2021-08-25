# frozen_string_literal: true
module Geoblacklight
  module Relation
    class Ancestors
      def initialize(id, field, repository)
        @search_id = id
        @field = field
        @repository = repository
      end

      def create_search_params
        { fq: ["{!join from=#{@field} to=#{Settings.FIELDS.UNIQUE_KEY}}#{Settings.FIELDS.UNIQUE_KEY}:#{@search_id}"],
          fl: [Settings.FIELDS.TITLE, Settings.FIELDS.UNIQUE_KEY, Settings.FIELDS.GEOM_TYPE] }
      end

      def execute_query
        @repository.connection.send_and_receive(
          @repository.blacklight_config.solr_path,
          params: create_search_params
        )
      end

      def results
        response = execute_query
        response['response']
      end
    end
  end
end
