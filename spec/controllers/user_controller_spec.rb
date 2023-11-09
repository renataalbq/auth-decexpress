
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'when user with unique email is created' do
      it 'returns a 200 status code and a user with a token' do
        post :create, params: { name: 'Renata Albuquerque', email: 'renataalbq@email.com', password: 'password', isAdmin: false }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('user', 'token')
      end
    end

    context 'when user with existing email is created' do
      it 'returns a 422 status code and an error message' do
        existing_user = create(:user, email: 'renata@email.com')
        post :create, params: { name: 'Renata', email: 'renata@email.com', password: 'password', isAdmin: false }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Email já cadastrado')
      end
    end

    # Add more test cases as needed
  end

  describe 'POST #login' do
    context 'when valid login credentials are provided' do
      it 'returns a 200 status code and a user with a token' do
        user = create(:user, email: 'john@example.com', password: 'password')
        post :login, params: { email: 'john@example.com', password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('user', 'token')
      end
    end

    context 'when invalid login credentials are provided' do
      it 'returns a 422 status code and an error message' do
        post :login, params: { email: 'nonexistent@example.com', password: 'wrongpassword' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Campos inválidos')
      end
    end
  end

end