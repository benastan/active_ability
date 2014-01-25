require 'active_ability/controller_proxy'

module ActiveAbility
  module Controller
    module InstanceMethods
      attr_reader :ability_request
      
      def abilities
        ability_request.abilities
      end
    end

    protected

    class << self
      def extended(klass)
        ControllerProxy.new(klass)
      end
    end
  end
end