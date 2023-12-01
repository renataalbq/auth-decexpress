class AddNomeToGrades < ActiveRecord::Migration[7.0]
  def change
    add_column :grades, :nome, :string
  end
end
