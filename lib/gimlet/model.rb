require 'forwardable'
require 'gimlet'
require 'gimlet/queryable'

module Gimlet
  module Model
    extend Forwardable

    class IdMissing < StandardError; end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include Queryable::API

      def find(id)
        @instances[id.to_s]
      end

      def source(source)
        @instances = {}
        source.each do |item|
          id = data = nil
          case item
          when Array
            id, data = item
          when Hash
            data = item
            id = data['id']
          end

          unless id
            raise IdMissing, 'Missing id property for %s' % [data.inspect]
          end

          @instances[id.to_s] = self.new(data)
        end
      end

      def scope(name, body)
        singleton_class.send(:define_method, name) do |*args|
          scope = body.call(*args)
          scope || all
        end
      end

      attr_accessor :current_scope
    end

    def initialize(data)
      @data = data
    end

    def to_param
      id
    end

    def_delegators :@data, :[], :method_missing, :to_h
  end
end
