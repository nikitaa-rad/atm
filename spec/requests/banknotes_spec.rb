require "rails_helper"

RSpec.describe V1::Banknotes, type: :request do
  let(:base_url) { "/api/v1/atm_devices/#{atm_device.id}/banknotes" }

  let(:atm_device) { create :atm_device }

  describe 'POST /v1/atm_devices/:atm_device_id/banknotes' do
    let(:params) { Hash('10' => 4) }

    it 'calls Banknotes::Purchase' do
      expect(Banknotes::Purchase).to receive(:call)
                                       .with(atm_device: atm_device, banknotes: { '10' => 4 })
                                       .and_call_original

      post base_url, params: params

      expect_status(201)
    end

    it 'returns transaction' do
      post base_url, params: params

      expect_status(201)
      expect_json('10', 4)
    end
  end

  describe 'POST /v1/atm_devices/:atm_device_id/banknotes' do
    let(:params) { Hash('total' => 1) }

    before { create :banknote_quantity, atm_device: atm_device, nominal: '1', amount: 10 }

    it 'calls Banknotes::Withdraw' do
      expect(Banknotes::Withdraw).to receive(:call)
                                       .with(atm_device: atm_device, total: 1)
                                       .and_call_original

      patch base_url, params: params

      expect_status(200)
    end

    it 'returns transaction' do
      patch base_url, params: params

      expect_status(200)
      expect_json('1', 1)
    end
  end
end
