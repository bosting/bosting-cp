require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'

module Rails
  module Generators
    class GaurangaControllerGenerator < ScaffoldControllerGenerator
      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :show, :type => :boolean, :default => true, :desc => "With show action"

      private
      def redirect_to_url
        if options.show?
          "@#{singular_table_name}"
        else
          "#{index_helper}_path"
        end
      end
    end
  end
end
