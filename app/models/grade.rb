class Grade < ApplicationRecord
    belongs_to :document, optional: true
    validates :nome, :matricula, :professor, :disciplina, :nota, :bimestre, :email, presence: true
    validates :nota, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    validates :bimestre, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4 }
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
