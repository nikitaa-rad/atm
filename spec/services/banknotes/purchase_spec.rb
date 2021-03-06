require 'rails_helper'

RSpec.describe Banknotes::Purchase do
  let(:atm_device) { create :atm_device }

  subject { described_class.call(atm_device: atm_device, banknotes: banknotes) }

  context 'with invalid params' do
    context 'when banknote amount is less than 0' do
      let(:banknotes) { Hash('10' => -1) }

      it 'raises Banknotes::ParameterError' do
        expect { subject }.to raise_error(Banknotes::ParameterError, 'BANKNOTE_AMOUNT_SHOULD_BE_GREATER_THAN_0')
      end
    end

    context 'when no allowed banknote was added' do
      let(:banknotes) { Hash.new }

      it 'raises Banknotes::ParameterError' do
        expect { subject }.to raise_error(Banknotes::ParameterError, 'YOUR_BANKNOTES_ARE_NOT_ACCEPTED')
      end
    end
  end

  context 'with valid params' do
    let(:banknotes) { Hash('10' => 2) }

    context 'with transactions' do
      it 'creates atm transaction' do
        expect { subject }.to change { atm_device.transactions.purchasing.count }.by(1)
      end

      it 'returns created transaction with purchased banknotes' do
        expect(subject.banknotes).to eq(banknotes)
      end
    end

    context 'with banknote_quantity' do
      context 'when atm does not have such banknotes' do
        it 'creates banknote' do
          expect { subject }.to change { atm_device.banknote_quantities.count }.by(1)
        end
      end

      context 'when atm has such banknotes' do
        let!(:banknote_quantity) { create :banknote_quantity, atm_device: atm_device, nominal: '10', amount: 134 }

        it 'does not create banknote' do
          expect { subject }.to change { atm_device.banknote_quantities.count }.by(0)
        end

        it 'updates existing banknote amount' do
          expect { subject }.to change { banknote_quantity.reload.amount }.to(136)
        end
      end
    end
  end
end
