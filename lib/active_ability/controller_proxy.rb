require 'active_ability/ability_request'

module ActiveAbility
  class ControllerProxy < Struct.new(:controller_class)
    def initialize(controller_class)
      super(controller_class)
      controller_class.before_filter before_filter
    end

    def before_filter
      Proc.new do
        ActiveAbility::AbilityRequest.new(self)
      end
    end
  end
end