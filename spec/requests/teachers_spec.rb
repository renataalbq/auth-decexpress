require 'rails_helper'

RSpec.describe "Teachers", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get teachers_url, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      teacher = Teacher.create(name: "João Silva")
      get teacher_url(teacher), as: :json
      expect(response).to be_successful
    end
  end
end
