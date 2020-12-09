module V1
  class Banknotes < Grape::API
    include V1::Defaults

    resource :atm_devices do
      route_param :atm_device_id do
        resource :banknotes do
          desc 'Adds money to the atm'
          params do
            BanknoteQuantity::AVAILABLE_NOMINAL.each do |nominal|
              optional nominal, type: Integer
            end
          end
          post do
            atm_device = AtmDevice.find(params[:atm_device_id])

            error!('YOUR_BANKNOTES_ARE_NOT_ACCEPTED', 400) unless permitted_params.keys.present?
            error!('BANKNOTE_AMOUNT_SHOULD_BE_GREATER_THAN_0', 400) unless permitted_params.values.all?(&:positive?)

            ::Banknotes::Purchase.call(atm_device: atm_device, banknotes: permitted_params)

          end
        end
      end
    end
  end
end
