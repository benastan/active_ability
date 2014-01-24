module ActiveAbility
  class ControllerProxy < Struct.new(:controller_class)
    def initialize(controller_class)
      super(controller_class)
      controller_class.before_filter Proc.new {}
    end

    def before_filter
      Proc.new do
        abilities = ActiveAbility::Ability.query_abilities(params)
        abilities.collect do |ability_class|
          params_conditions = ability_class.match_params(params)
          ordered_params = params_conditions.params.collect do |param|
            params[param]
          end
          ability_class.new(*ordered_params)
        end
      end
    end
  end
end