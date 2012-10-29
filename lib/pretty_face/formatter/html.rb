require 'erb'
require 'cucumber/formatter/io'

module PrettyFace
  module Formatter
    class Html
      include Cucumber::Formatter::Io

      def initialize(step_mother, path_or_io, options)
        @io = ensure_io(path_or_io, 'html')
        @step_mother = step_mother
        @options = options
      end

      def after_features(features)
        filename = File.join(File.dirname(__FILE__), '..', 'templates', 'main.erb')
        text = File.new(filename).read
        renderer = ERB.new(text, nil, "%")
        @io.puts renderer.result
      end
    end
  end
end