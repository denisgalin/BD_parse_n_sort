class TransactionsController < ApplicationController
  def sort
    sorter = TransactionSorter.new(params[:file_path])
    sorter.external_sort

    render plain: "Sorting complete. Output written to 'sorted_transactions.txt'."
  end
end
