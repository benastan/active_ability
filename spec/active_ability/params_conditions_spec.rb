require 'spec_helper'

describe ActiveAbility::ParamsConditions do
  let(:params) { ActiveAbility::ParamsConditions.new(:book_id) }
  describe '#initialize' do
    it 'sets @params' do
      params.instance_variable_get(:@params).should include :book_id
    end
  end
  describe '#match?' do
    context 'when the params match' do
      specify { params.match?(book_id: 1).should be }
    end
    context 'when the params don\'t match' do
      specify { params.match?(book_id: 1, author_id: 1).should_not be }
    end
  end
end