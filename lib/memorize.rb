# frozen_string_literal: true

require_relative "memorize/version"

module Memorize
  class Error < StandardError; end
  # Your code goes here...
  def self.included(klass)
    class << klass
      alias_method :__new, :new
      def new(*args)
        e = __new $args
        e.after_init

        e
      end
    end

    def after_init

    end
  end
end
