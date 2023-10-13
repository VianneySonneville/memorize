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

  def after_init(*args)
    session_define?
    args.empty? ? hydrate : memorize
  end

  private

  def hydrate
    self.attributes = Current.session[get_key] if key_define?
  end

  def get_key
    "#{self.class.name}_#{Current.session.id}"
  end

  def key_define?
    Current.session[get_key].present?
  end

  def memorize
    Current.session[get_key] = attributes
  end

  def session_define?
    raise Exception.new "#{class_name} must have a session attribute defined \n ie \n or have a Current.session define" if Current.session.nil?
  end

  def clean
    # Rails.cache.delete_multi attributes.keys
  end
end
