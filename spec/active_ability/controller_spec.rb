require 'spec_helper'

describe ActiveAbility::Controller do
  subject(:klass) { Class.new }
  describe '.extended' do
    it 'instantiates a controller proxy' do
      klass.stub(:before_filter) { nil }
      ActiveAbility::ControllerProxy.should_receive(:new).with(klass)
      klass.extend(ActiveAbility::Controller)
    end

    it 'adds a before filter' do
      klass.should_receive(:before_filter)
      klass.extend(ActiveAbility::Controller)
    end
  end 
end