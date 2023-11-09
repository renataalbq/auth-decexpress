class RemoveMatriculaFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :matricula, :string
  end
end
