require "rails_helper"

RSpec.describe V1::Banknotes, type: :request do
  let(:base_url) { "/api/v1/atm_devices/#{atm_device.id}/banknotes" }

  let(:atm_device) { create :atm_device }

  describe 'POST v1/atm_devices/:atm_device_id/banknotes' do
    context 'with invalid params' do
      it 'returns 400 if banknote amount is less than 0' do
        post base_url, params: { '10' => -1 }

        expect_status(400)
        expect_json(error: 'BANKNOTE_AMOUNT_SHOULD_BE_GREATER_THAN_0')
      end

      it 'returns 400 if not allowed banknotes were added' do
        post base_url, params: { '123' => 20 }

        expect_status(400)
        expect_json(error: 'YOUR_BANKNOTES_ARE_NOT_ACCEPTED')
      end
    end

    context 'with valid params' do
      it 'calls Banknotes::Purchase' do
        expect(Banknotes::Purchase).to receive(:call)
                                         .with(atm_device: atm_device, banknotes: { '10' => 4 })
                                         .and_call_original

        post base_url, params: { '10' => 4 }

        expect_status(201)
      end

      it 'returns transaction' do
        post base_url, params: { '10' => 4 }

        expect_status(201)
        expect_json('10', 4)
      end
    end
  end
end
