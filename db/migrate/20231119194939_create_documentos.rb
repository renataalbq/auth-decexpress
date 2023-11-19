class CreateDocumentos < ActiveRecord::Migration[7.0]
  def change
    create_table :documentos do |t|
      t.date :data_solicitacao
      t.date :data_validade
      t.string :tipo
      t.string :matricula
      t.string :cpf
      t.string :nome_aluno
      t.string :url

      t.timestamps
    end
  end
end
