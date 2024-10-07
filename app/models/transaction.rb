class Transaction
  include ActiveModel::Model

  attr_accessor :timestamp, :transaction_id, :user_id, :amount

  def initialize(attributes = {})
    @timestamp = attributes[:timestamp]
    @transaction_id = attributes[:transaction_id]
    @user_id = attributes[:user_id]
    @amount = attributes[:amount]
  end
end
