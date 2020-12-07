module V1
  class Atms < Grape::API
    include V1::Defaults

    resource :atms do
      # desc "Return all graduates"
      # get "", root: :graduates do
      #   Graduate.all
      # end
      desc 'Get atm'
      get do
        AtmDevice.all
      end
    end
  end
end
