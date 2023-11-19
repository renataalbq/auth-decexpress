class RemoveUrlFromDocuments < ActiveRecord::Migration[7.0]
  def change
    remove_column :documents, :url, :string
  end
end
