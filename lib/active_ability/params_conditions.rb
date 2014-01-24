module ActiveAbility
  class ParamsConditions
    attr_reader :params
    
    def initialize(*params)
      @params = params
    end

    def match?(params)
      params.keys == @params
    end
  end
end