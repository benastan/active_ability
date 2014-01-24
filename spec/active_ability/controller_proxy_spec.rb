require 'spec_helper'

describe ActiveAbility::ControllerProxy do
  let(:controller_class) { double(:controller_class, before_filter: nil) }
  let(:controller) { double(:controller) }
  let(:ability_class) do
    klass = Class.new
    klass.extend(ActiveAbility::Ability)
    klass
  end

  subject(:controller_proxy) { ActiveAbility::ControllerProxy.new(controller_class) }

  describe '#initialize' do
    it 'adds a before filter to the controller' do
      controller_class.unstub(:before_filter)
      controller_class.should_receive(:before_filter)
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

      it 'evaluates the proc in the context of the controller' do
        controller.should_receive(:params) { {} }
        call_filter
      end

      context 'when there are matching abilities' do
        it 'instantiates each ability' do
          controller.stub(:params) { { book_id: 1 } }
          ability_class.stub(:new)
          ability_class.authorizes :book_id
          call_filter
        end
      end
    end
  end
end