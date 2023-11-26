# spec/models/document_spec.rb

require 'rails_helper'

RSpec.describe Document, type: :model do
  it 'É válido com atributos válidos' do
    document = Document.new(data_solicitacao: Date.today, data_validade: Date.today + 1.year, tipo: "declaracao", matricula: "12345", cpf: "12345678900", nome_aluno: "Aluno Teste")
    expect(document).to be_valid
  end

  it 'É inválido sem matricula' do
    document = Document.new(matricula: nil)
    expect(document).not_to be_valid
  end

end
