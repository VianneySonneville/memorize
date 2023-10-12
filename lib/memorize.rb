# frozen_string_literal: true

require_relative 'memorize/version'

module Memorize
  def self.included(klass)
    class << klass
      alias_method :__new, :new
      def new(*args)
        e = __new args
        e.after_init

        e
      end
    end
  end

  private

  def after_init; end

  def memorize
    Rails.cache.write_multi attributes, expires_in: 10.minutes
  end

  def hydrate
    attributes = Rails.cache.read_multi attributes.keys
  end

  def clean
    Rails.cache.delete_multi attributes.keys
  end
end
