module Banknotes
  class ParameterError < StandardError
    def initialize(msg)
      super(msg)
    end
  end
end