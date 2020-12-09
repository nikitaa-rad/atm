require 'rails_helper'

RSpec.describe Banknotes::Purchase do
  let(:atm_device) { create :atm_device }

  let(:banknotes) { Hash('10' => 2) }

  subject { described_class.call(atm_device: atm_device, banknotes: banknotes) }

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
