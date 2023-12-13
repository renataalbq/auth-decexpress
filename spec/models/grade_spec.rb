require 'rails_helper'

RSpec.describe Grade, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      grade = Grade.new(
        nome: "Renata Albuquerque",
        matricula: "12345",
        professor: "João",
        disciplina: "Matematica",
        nota: 9,
        bimestre: 1,
        email: "renata@email.com"
      )
      expect(grade).to be_valid
    end

    it "is not valid with invalid attributes" do
      grade = Grade.new(
        nome: nil,
        matricula: "12345",
        professor: "Teste",
        disciplina: "Matematica",
        nota: 105, 
        bimestre: 5,
        email: "invalid_email"
      )
      expect(grade).not_to be_valid
    end
  end
end
