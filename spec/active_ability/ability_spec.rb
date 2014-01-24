require 'spec_helper'

describe ActiveAbility::Ability do
  subject(:klass) { Class.new }
  def extend_klass
    klass.extend(ActiveAbility::Ability)
  end
  describe '.included' do
    it 'adds the class to .abilities' do
      expect do
        extend_klass
      end.to change(ActiveAbility::Ability.ability_classes, :count).by(1) 
    end
  end
  describe '.query_abilities' do
    def make_ability
      klass = Class.new
      klass.extend(ActiveAbility::Ability)
      klass
    end
    let!(:first_ability) do
      klass = make_ability
      klass.authorizes :book_id
      klass.authorizes :author_id, :book_id
      klass
    end
    let!(:second_ability) do
      klass = make_ability
      klass.authorizes :author_id
      klass.authorizes :author_id, :book_id
      klass
    end
    let(:params) { {} }
    subject (:abilities) { ActiveAbility::Ability.query_abilities(params) }
    context 'when there is only one matching ability' do
      before { params[:book_id] = 1 }
      specify { abilities.count.should == 1 }
      it { should include first_ability }
    end
  end
  describe '#authorizes' do
    before do
      extend_klass
    end
    it 'adds a ParamsConditions object to #params' do
      ActiveAbility::ParamsConditions.should_receive(:new).with(:book_id).and_call_original
      expect do
        klass.authorizes :book_id
      end.to change(klass.params_conditions, :count).by(1)
    end
    context 'when the last parameter is a hash' do
      it 'assigns the hash to #options' do
        klass.authorizes :author_id, through: :current_user, allow: :book_id
        klass.options.should include(through: :current_user)
      end
    end
  end
  describe '#match?' do
    before do
      extend_klass
    end
    context 'when the params match up' do
      specify do
        klass.authorizes :book_id
        klass.match?(book_id: 1).should be
      end
    end
    context 'when there are multiple params conditions' do
      specify do
        klass.authorizes :book_id
        klass.authorizes :book_id, :author_id
        klass.match?(book_id: 1).should be
      end
    end
    context 'when the params do not match up' do
      specify do
        klass.authorizes :book_id
        klass.match?(book_id: 1, author_id: 2).should_not be
      end
      specify do
        klass.authorizes :book_id, :author_id
        klass.match?(book_id: 1).should_not be
      end
    end
  end
  describe '#match_params' do
    before do
      extend_klass
    end
    context 'when there is a matching params conditions' do
      it 'returns the params conditions' do
        klass.authorizes :book_id
        klass.match_params(book_id: 1).should be_a ActiveAbility::ParamsConditions
      end
    end
    context 'when there is not a matching params conditions' do
      it 'returns nil' do
        klass.match_params(book_id: 1).should be_nil
      end
    end
  end
end