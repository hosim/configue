# coding: utf-8

require "configue/container_adapter"
require "configue/criteria"

module Configue
  # +Configue::Container+ is a setting solution using a YAML file.
  #
  # When you have such configuration files:
  #
  #    # config/accounts/admin_users.yml
  #    accounts:
  #      admin_users:
  #        - grumpy
  #        - sneezy
  #
  #    # config/accounts/test_users.yml
  #    accounts:
  #      test_users:
  #        - sleepy
  #        - dopey
  #
  # this could be:
  #
  #    class Foo < Configue::Container
  #      config.source_dir "#{File.dirname(__FILE__)}/config"
  #    end
  #
  #    Foo.accounts.admin_users
  #    # => ["grumpy", "sneezy"]
  #
  #    Foo.accounts.test_users
  #    # => ["sleepy", "dopey"]
  #
  class Container < Node

    # When you do not know the setting has keys that you want to
    # specify and want to avoid +NoMethodError+, you could use
    # +query+ and +retrieve+.
    #
    #   Foo.query("accounts.admin_users").retrieve
    #   # => ["grumpy", "sneezy"]
    #
    #   Foo.query("users.admin_users").retrieve
    #   # => nil
    #
    #   Foo.query[:accounts][:admin_users].retrieve
    #   # => ["grumpy", "sneezy"]
    #
    def query(key=nil)
      q = Criteria.new(self)
      q = key.split('.').each.inject(q) {|c, k| c[k] } if key
      q
    end

    class << self
      # +config+ allows you to access the object for setting container.
      def config
        @config_access_name = "config"
        @setting ||= Setting.new(ContainerAdapter.new(self))
      end

      def config_setting
        @config_access_name = "config_setting"
        @setting ||= Setting.new(ContainerAdapter.new(self))
      end

      private
      def method_missing(name, *args, &block)
        # makes @instance in this line.
        @setting.load!

        if @instance.key?(name)
          @instance[name]
        else
          @instance.__send__(name, *args, &block)
        end
      end
    end
  end
end
