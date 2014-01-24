require 'active_ability'

Rspec.configure do |config|
  config.before(:each) do
    ActiveAbility::Ability.instance_variable_set(:@ability_classes, [])
  end
end