class TransactionSorter
  Transaction = Struct.new(:timestamp, :transaction_id, :user_id, :amount)

  def initialize(file_path)
    @file_path = file_path
  end

  def parse_transaction(line)
    timestamp, transaction_id, user_id, amount = line.split(',')
    Transaction.new(Time.parse(timestamp), transaction_id, user_id, amount.to_f)
  end

  def merge_sort(transactions)
    return transactions if transactions.size <= 1

    mid = transactions.size / 2
    left = merge_sort(transactions[0...mid])
    right = merge_sort(transactions[mid...transactions.size])
    merge(left, right)
  end

  def merge(left, right)
    sorted = []
    until left.empty? || right.empty?
      sorted << if left.first.amount >= right.first.amount
                  left.shift
                else
                  right.shift
                end
    end
    sorted.concat(left).concat(right)
  end

  def sort_block(transactions, index)
    sorted_transactions = merge_sort(transactions)
    File.open("sorted_block_#{index}.txt", 'w') do |file|
      sorted_transactions.each do |transaction|
        file.puts("#{transaction.timestamp},#{transaction.transaction_id},#{transaction.user_id},#{transaction.amount}")
      end
    end
  end

  def external_sort(block_size = 1000)
    transactions = []
    block_index = 0

    File.foreach(@file_path).with_index do |line, index|
      transactions << parse_transaction(line)
      if transactions.size >= block_size
        sort_block(transactions, block_index)
        transactions.clear
        block_index += 1
      end
    end

    sort_block(transactions, block_index) unless transactions.empty?
    merge_sorted_blocks(block_index + 1)
  end

  def merge_sorted_blocks(block_count)
    files = (0...block_count).map { |i| File.open("sorted_block_#{i}.txt") }
    output_file = File.open('sorted_transactions.txt', 'w')

    current_transactions = files.map do |file|
      parse_transaction(file.readline)
    rescue StandardError
      nil
    end

    until current_transactions.compact.empty?
      max_transaction, max_index = current_transactions.each_with_index.compact.max_by { |t, _| t.amount }
      output_file.puts("#{max_transaction.timestamp},#{max_transaction.transaction_id},#{max_transaction.user_id},#{max_transaction.amount}")
      begin
        current_transactions[max_index] = parse_transaction(files[max_index].readline)
      rescue EOFError
        current_transactions[max_index] = nil
      end
    end

    files.each(&:close)
    output_file.close
  end
end
