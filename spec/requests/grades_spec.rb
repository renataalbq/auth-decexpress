require 'rails_helper'

RSpec.describe "/grades", type: :request do
  let(:valid_attributes) {
    {
      nome: "Renata Albuquerque",
      matricula: "12345",
      professor: "João",
      disciplina: "Matematica",
      nota: 9,
      bimestre: 1,
      email: "renata@email.com"
    }
  }

  let(:invalid_attributes) {
    {
      nome: nil,
      matricula: "12345",
      professor: "Teste",
      disciplina: "Matematica",
      nota: 105, 
      bimestre: 5,
      email: "invalid_email"
    }
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Grade.create! valid_attributes
      get grades_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      grade = Grade.create! valid_attributes
      get grade_url(grade), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Grade" do
        expect {
          post grades_url,
               params: { grade: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Grade, :count).by(1)
      end

      it "renders a JSON response with the new grade" do
        post grades_url,
             params: { grade: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Grade" do
        expect {
          post grades_url,
               params: { grade: invalid_attributes }, as: :json
        }.to change(Grade, :count).by(0)
      end

      it "renders a JSON response with errors for the new grade" do
        post grades_url,
             params: { grade: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          nota: 9,
          bimestre: 2
        }
      }

      it "updates the requested grade" do
        grade = Grade.create! valid_attributes
        patch grade_url(grade),
              params: { grade: new_attributes }, headers: valid_headers, as: :json
        grade.reload
        expect(grade.nota).to eq(9)
        expect(grade.bimestre).to eq(2)
      end

      it "renders a JSON response with the grade" do
        grade = Grade.create! valid_attributes
        patch grade_url(grade),
              params: { grade: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the grade" do
        grade = Grade.create! valid_attributes
        patch grade_url(grade),
              params: { grade: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested grade" do
      grade = Grade.create! valid_attributes
      expect {
        delete grade_url(grade), headers: valid_headers, as: :json
      }.to change(Grade, :count).by(-1)
    end
  end
end
