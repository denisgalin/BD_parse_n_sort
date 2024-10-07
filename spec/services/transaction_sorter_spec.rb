# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionSorter, type: :service do
  let(:transaction1) { Transaction.new(timestamp: Time.parse('2023-09-03T12:45:00Z'), transaction_id: 'txn12345', user_id: 'user987', amount: 500.25) }
  let(:transaction2) { Transaction.new(timestamp: Time.parse('2023-09-03T13:00:00Z'), transaction_id: 'txn12346', user_id: 'user988', amount: 300.75) }
  let(:transaction3) { Transaction.new(timestamp: Time.parse('2023-09-03T14:30:00Z'), transaction_id: 'txn12347', user_id: 'user989', amount: 750.50) }

  it 'parses a transaction from string' do
    line = '2023-09-03T12:45:00Z,txn12345,user987,500.25'
    sorter = TransactionSorter.new('dummy_path')
    transaction = sorter.parse_transaction(line)
    expect(transaction.timestamp).to eq(Time.parse('2023-09-03T12:45:00Z'))
    expect(transaction.transaction_id).to eq('txn12345')
    expect(transaction.user_id).to eq('user987')
    expect(transaction.amount).to eq(500.25)
  end

  it 'sorts transactions by amount in descending order' do
    sorter = TransactionSorter.new('dummy_path')
    transactions = [transaction1, transaction2, transaction3]
    sorted_transactions = sorter.merge_sort(transactions)
    expect(sorted_transactions.first).to eq(transaction3)
    expect(sorted_transactions.last).to eq(transaction2)
  end
end
