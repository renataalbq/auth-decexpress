class Document < ApplicationRecord
    has_many :grades
    validates :data_solicitacao, :data_validade, :tipo, :matricula, :cpf, :nome_aluno, :email_aluno, presence: true
    validates :email_aluno, format: { with: URI::MailTo::EMAIL_REGEXP }
end
