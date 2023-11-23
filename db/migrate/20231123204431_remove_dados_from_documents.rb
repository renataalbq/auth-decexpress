class RemoveDadosFromDocuments < ActiveRecord::Migration[7.0]
  def change
    remove_column :documents, :dados, :string
  end
end
