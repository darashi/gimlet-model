require 'forwardable'

module Gimlet
  module Queryable
    module API
      extend Forwardable

      def select(options = {})
        selecting = @instances
        options[:where].each do |attribute, operator, argument|
          selecting = selecting.select do |id, instance|
            instance[attribute].send(operator, argument)
          end
        end
        selecting.values
      end

      def new_query
        current_scope || Query.new(self)
      end

      def_delegators :new_query, :all, :where, :first, :last, :count
    end

    class Query
      include Enumerable
      extend Forwardable

      def initialize(model)
        @model = model
        @where = []
      end

      def where(hash)
        hash.each do |attribute, value|
          case value
          when Array
            @where.push([attribute, :in?, value]) # should be :== ?
          when Regexp
            @where.push([attribute, :=~, value])
          else
            @where.push([attribute, :==, value])
          end
        end
        self
      end

      def all
        @model.select(:where => @where)
      end

      def method_missing(method, *args, &block)
        if @model.respond_to?(method)
          scoping { @model.send(method, *args, &block) }
        else
          super
        end
      end

      def scoping
        previous, @model.current_scope = @model.current_scope, self
        yield
      ensure
        @model.current_scope = previous
      end

      def_delegators :all, :each, :first, :last
    end
  end
end
