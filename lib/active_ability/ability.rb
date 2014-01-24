require 'active_ability/params_conditions'

module ActiveAbility
  module Ability
    attr_reader :options

    def authorizes(*params)
      @options = params.pop unless Symbol === params.last
      params_conditions.push(ParamsConditions.new(*params))
    end

    def params_conditions
      @params_conditions ||= []
    end

    def match_params(params)
      params_conditions.select do |params_conditions|
        params_conditions.match?(params)
      end.first
    end

    def match?(params)
      ! match_params(params).nil?
    end

    class << self
      def ability_classes
        @ability_classes ||= []
      end

      def extended(klass)
        ability_classes << klass
      end

      def query_abilities(params)
        ability_classes.select do |ability_class|
          ability_class.match?(params)
        end
      end
    end
  end
end