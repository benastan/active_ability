module ActiveAbility
  class ParamsConditions
    attr_reader :params
    
    def initialize(*params)
      @params = params
    end

    def order_params_values(unordered_params)
      params.collect do |param|
        unordered_params[param]
      end
    end

    def match?(params_to_match)
      params_to_match.keys.sort == params.sort
    end
  end
end