FactoryBot.define do
  factory :document do
    data_solicitacao { "2023-11-19" }
    data_validade { "2023-11-19" }
    tipo { "MyString" }
    matricula { "MyString" }
    cpf { "MyString" }
    nome_aluno { "MyString" }
    dados { "" }
  end
end
