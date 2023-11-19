require 'rails_helper'

RSpec.describe Document, type: :model do
  it "is valid with valid attributes" do
    document = Document.new(data_solicitacao: Date.today, data_validade: Date.today + 1.year, tipo: "declaracao", matricula: "12345", cpf: "123.456.789-00", nome_aluno: "Aluno Teste", url: "declaracao_pdf")
    expect(document).to be_valid
  end

end