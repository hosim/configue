# coding: utf-8

require "forwardable"
require "configue/criteria"

module Configue
  class Container
    extend Forwardable

    def_delegators :@node, :keys, :key?, :has_key?, :[]

    def initialize(hash)
      @node = hash
    end

    def query(key=nil)
      q = Criteria.new(@node)
      q = key.split('.').each.inject(q) {|c, k| c[k] } if key
      q
    end

    class << self
      def config
        @setting ||= Setting.new(self)
      end
      alias_method :config_setting, :config

      private
      def method_missing(name, *args, &block)
        @instance ||= new(@setting.load_source)
        if @instance.key?(name)
          @instance[name]
        else
          @instance.__send__(name, *args, &block)
        end
      end
    end
  end
end
