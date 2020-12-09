module Banknotes
  class Withdraw
    attr_reader :atm_device

    def initialize(atm_device:, total:)
      @atm_device = atm_device
      @total = total
      @transaction = {}
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      ActiveRecord::Base.transaction do
        build_transaction

        check_total

        update_banknote_quantities

        save_transaction
      end
    end

    private

    def build_transaction
      sorted_banknote_quantities.each do |banknote, quantity|
        break if @total.zero?

        division = @total.div(banknote.to_i)

        if division <= quantity
          @total = @total - division * banknote.to_i
          @transaction[banknote] = division
        else
          @total = @total - quantity * banknote.to_i
          @transaction[banknote] = quantity
        end
      end
    end

    def check_total
      raise ::Banknotes::ParameterError.new('CAN_NOT_WITHDRAW_SUCH_AMOUNT') unless @total.zero?
    end

    def update_banknote_quantities
      atm_device.banknote_quantities.each do |banknote_quantity|
        if @transaction[banknote_quantity.nominal].present?
          banknote_quantity.amount = banknote_quantity.amount - @transaction[banknote_quantity.nominal]

          banknote_quantity.save!
        end
      end
    end

    def save_transaction
      atm_device.transactions.create!(
        transaction_type: Transaction.transaction_types[:withdrawal],
        banknotes: @transaction
      )
    end

    def sorted_banknote_quantities
      @loaded_banknote_quantities ||= atm_device
                                        .banknote_quantities
                                        .in_stock
                                        .pluck(:nominal, :amount)
                                        .sort_by { |banknote, quantity| -banknote }
                                        .to_h
    end

  end
end
