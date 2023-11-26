require 'rails_helper'

RSpec.describe "/users", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { { name: 'Test User', email: 'test@example.com', password: 'password' } }
  let(:valid_attributes) {
    { name: 'Novo Usuario', email: 'usuario@example.com', password: 'senha123', isAdmin: false }
  }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post users_url, params: valid_attributes
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        { name: nil, email: nil, password: nil, isAdmin: nil }
      }

      it "does not create a new User" do
        expect {
          post users_url, params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it "renders a JSON response with errors for the new user" do
        post users_url, params: invalid_attributes
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe 'POST /login' do
    it 'authenticates the user' do
      post '/login', params: { email: user.email, password: user.password }
      expect(response).to have_http_status(:ok)
    end

    it 'returns error with invalid credentials' do
      post '/login', params: { email: user.email, password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /index" do
    it "renders a successful response" do
      User.create! valid_attributes
      get users_url
      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including("application/json"))
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes a user' do
      delete "/users/#{user.id}"
      expect(response).to have_http_status(:ok)
    end
  end
end
