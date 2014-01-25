require 'spec_helper'

describe ActiveAbility::AbilityRequest do
  let(:controller) { double(:controller, params: { book_id: 1 }) }

  let(:ability_class) do
    klass = Class.new
    klass.extend(ActiveAbility::Ability)
    klass
  end

  subject(:ability_request) { ActiveAbility::AbilityRequest.new(controller)  }

  describe '#initialize' do
    its(:controller) { should == controller }
    its(:params) { should include({ book_id: 1 }) }

    it 'calls finds matching abilities' do
      ActiveAbility::Ability.stub(:instantiate_matching_ability_classes) { 'banana fries' }
      ability_request.abilities.should == 'banana fries'
      ActiveAbility::Ability.unstub(:instantiate_matching_ability_classes)
    end

    it 'extends the controller with ActiveAbility::Controller::InstanceMethods' do
      controller.should_receive(:extend).with(ActiveAbility::Controller::InstanceMethods)
      ability_request
    end

    it 'sets the controller\'s #ability_request' do
      ability_request
      controller.ability_request.should == ability_request
    end
  end
end
