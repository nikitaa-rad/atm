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
      raise ::Banknotes::ParameterError.new('YOUR_BANKNOTES_ARE_NOT_ACCEPTED') unless banknotes.keys.present?
      raise ::Banknotes::ParameterError.new('BANKNOTE_AMOUNT_SHOULD_BE_GREATER_THAN_0') unless banknotes.values.all?(&:positive?)

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
      atm_device.transactions.create!(
        transaction_type: Transaction.transaction_types[:purchasing],
        banknotes: banknotes
      )
    end
  end
end