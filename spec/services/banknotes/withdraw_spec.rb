require 'rails_helper'

RSpec.describe Banknotes::Withdraw do
  let(:atm_device) { create :atm_device }

  subject { described_class.call(atm_device: atm_device, total: total) }

  let!(:nominal_5_banknote) { create :banknote_quantity, atm_device: atm_device, nominal: '5', amount: 1 }
  let!(:nominal_10_banknote) { create :banknote_quantity, atm_device: atm_device, nominal: '10', amount: 2 }

  context 'with invalid params' do
    context 'with negative amount of banknotes' do
      let(:total) { -20 }

      it 'raises Banknotes::ParameterError' do
        expect { subject }.to raise_error(Banknotes::ParameterError, 'TOTAL_SHOULD_BE_GREATER_THAN_0')
      end
    end

    context 'with not enough amount of banknotes' do
      let(:total) { 30 }

      it 'raises Banknotes::ParameterError' do
        expect { subject }.to raise_error(Banknotes::ParameterError, 'CAN_NOT_WITHDRAW_SUCH_AMOUNT')
      end
    end
  end

  context 'with valid params' do
    let(:total) { 20 }

    context 'with banknote_quantity' do
      it 'reduces banknote quantity amount' do
        expect { subject }.to change { nominal_10_banknote.reload.amount }.to(0)
      end
    end

    context 'with transactions' do
      it 'creates atm transaction' do
        expect { subject }.to change { atm_device.transactions.withdrawal.count }.by(1)
      end

      it 'returns created transaction with purchased banknotes' do
        expect(subject.banknotes).to eq({ '10' => 2 })
      end
    end
  end
end
