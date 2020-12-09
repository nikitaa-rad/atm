require 'rails_helper'

RSpec.describe BanknoteQuantity, type: :model do
  context 'scopes' do
    describe '.in_stock' do
      subject { described_class.in_stock }

      let!(:in_stock_banknote) { create :banknote_quantity, nominal: '1', amount: 10 }

      before { create :banknote_quantity, nominal: '5', amount: 0 }

      it 'returns only in_stock banknote_quantity' do
        is_expected.to contain_exactly(in_stock_banknote)
      end
    end
  end
end
