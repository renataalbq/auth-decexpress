class AddEmailToGrades < ActiveRecord::Migration[7.0]
  def change
    add_column :grades, :email, :string
  end
end
