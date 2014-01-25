require 'spec_helper'

describe ActiveAbility::ParamsConditions do
  let(:params_conditions) { ActiveAbility::ParamsConditions.new(:author_id, :book_id) }

  describe '#initialize' do
    it 'sets @params' do
      params_conditions.instance_variable_get(:@params).should include :book_id
    end
  end

  describe '#match?' do
    context 'when the params match' do
      specify { params_conditions.match?(book_id: 1, author_id: 5).should be }
    end

    context 'when the params don\'t match' do
      specify { params_conditions.match?(book_id: 1).should_not be }
    end
  end

  describe '#order_params_values' do
    let(:ordered_values) { params_conditions.order_params_values(cook_id: 3, author_id: 6, book_id: 10) }

    it 'returns the values in the correct order' do
      params_conditions.stub(:params) { [ :author_id, :book_id, :cook_id ]}
      ordered_values.should == [ 6, 10, 3 ]
    end
  end
end