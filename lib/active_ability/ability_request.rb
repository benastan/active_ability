module ActiveAbility
  class AbilityRequest < Struct.new(:controller)
    attr_reader :abilities, :params

    def initialize(*args)
      super(*args)
      @params = controller.params
      @abilities = ActiveAbility::Ability.instantiate_matching_ability_classes(params)
      controller.instance_variable_set(:@ability_request, self)
      controller.extend(ActiveAbility::Controller::InstanceMethods)
    end
  end
end
