require 'spec_helper'

describe ActiveAbility::ControllerProxy do
  let(:controller_class) { double(:controller_class, before_filter: nil) }
  let(:controller) { double(:controller) }

  subject(:controller_proxy) { ActiveAbility::ControllerProxy.new(controller_class) }

  describe '#initialize' do
    it 'adds a before filter to the controller' do
      controller_class.unstub(:before_filter)
      controller_class.should_receive(:before_filter)
      ActiveAbility::ControllerProxy.any_instance.should_receive(:before_filter)
      controller_proxy
    end
  end 

  describe '#before_filter' do
    it 'returns a proc' do
      controller_proxy.before_filter.should be_a Proc
    end

    describe 'calling the proc' do
      let(:filter) { controller_proxy.before_filter }

      def call_filter
        controller.instance_exec(&filter)
      end

      it 'instantiates an AbilityRequest' do
        ActiveAbility::AbilityRequest.should_receive(:new).with(controller)
        call_filter
      end
    end
  end
end