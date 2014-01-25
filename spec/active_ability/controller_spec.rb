require 'spec_helper'

describe ActiveAbility::Controller do
  subject(:klass) { Class.new }

  let(:fake_ability_request) { double(:ability_request, abilities: 'cake acronym') }

  let(:controller) do
    controller = klass.new
    controller.extend(ActiveAbility::Controller::InstanceMethods)
  end

  before do
    klass.stub(:before_filter) { nil }
  end

  def extend_klass
    klass.extend(ActiveAbility::Controller)
  end

  describe '.extended' do
    it 'instantiates a controller proxy' do
      ActiveAbility::ControllerProxy.should_receive(:new).with(klass)
      extend_klass
    end

    it 'adds a before filter' do
      klass.unstub(:before_filter)
      klass.should_receive(:before_filter)
      extend_klass
    end
  end 

  describe '#abilities' do
    it 'delegates to controller proxy' do
      extend_klass
      controller.stub(:ability_request) { fake_ability_request }
      controller.abilities.should == 'cake acronym'
    end
  end
end