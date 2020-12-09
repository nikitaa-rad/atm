module Banknotes
  class Purchase
    attr_reader :atm_device, :banknotes

    def initialize(atm_device:, banknotes:)
      @atm_device = atm_device
      @banknotes = banknotes
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      ActiveRecord::Base.transaction do
        update_banknote_quantities

        create_atm_transaction
      end
    end

    private

    def update_banknote_quantities
      banknotes.each do |nominal, quantity|
        banknote_quantity = atm_device.banknote_quantities.first_or_create(nominal: nominal)
        banknote_quantity.amount += quantity

        banknote_quantity.save!
      end
    end

    def create_atm_transaction
      atm_device.transactions.create!(banknotes: banknotes)
    end
  end
end