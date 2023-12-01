class AddBimestreToGrades < ActiveRecord::Migration[7.0]
  def change
    add_column :grades, :bimestre, :integer
  end
end
