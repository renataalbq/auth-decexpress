require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get subjects_url, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      teacher = Teacher.create(name: "João Silva")
      subject = Subject.create(name: "Matematica", teacher: teacher)
      get subject_url(subject), as: :json
      expect(response).to be_successful
    end
  end
end
