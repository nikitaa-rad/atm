module V1
  class Base < Grape::API
    mount V1::Atms
    # mount API::V1::AnotherResource
    # mount V1::Atms
  end
end
