class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.date :data_solicitacao
      t.date :data_validade
      t.string :tipo
      t.string :matricula
      t.string :cpf
      t.string :nome_aluno
      t.string :url
      t.binary :dados

      t.timestamps
    end
  end
end
