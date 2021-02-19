class ChangeTaxColumnForSales < ActiveRecord::Migration[6.0]
  def change
    change_column :sales, :tax, :integer, default: 0
  end
end
