class AddColumnToPosts2 < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :rate, :float
  end
end
