class AddEmailAlunoToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :email_aluno, :string
  end
end
