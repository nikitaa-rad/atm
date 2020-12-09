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
            error!('YOUR_BANKNOTES_ARE_NOT_ACCEPTED', 400) unless permitted_params.keys.present?
            error!('BANKNOTE_AMOUNT_SHOULD_BE_GREATER_THAN_0', 400) unless permitted_params.values.all?(&:positive?)

            transaction = ::Banknotes::Purchase.call(atm_device: atm_device, banknotes: permitted_params)

            transaction.banknotes
          end

          desc 'Withdraws money from the atm'
          params do
            requires :total, type: Integer
          end
          patch do
            error!('TOTAL_SHOULD_BE_GREATER_THAN_0', 400) unless permitted_params[:total].positive?

            transaction = ::Banknotes::Withdraw.call(atm_device: atm_device, total: permitted_params[:total])

            transaction.banknotes
          end
        end
      end
    end
  end
end
