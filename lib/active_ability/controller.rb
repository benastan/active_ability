require 'active_ability/controller_proxy'

module ActiveAbility
  module Controller
    protected

    class << self
      def extended(klass)
        ControllerProxy.new(klass)
      end
    end
  end
end