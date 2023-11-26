require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'token methods' do
    let(:user) { create(:user) }
    let(:token) { controller.encode_token({ user_id: user.id }) }

    it 'encodes a token' do
      expect(token).not_to be_nil
    end

    it 'decodes a token' do
      decoded_token = controller.decode_token(token)
      expect(decoded_token[0]['user_id']).to eq(user.id)
    end
  end

  describe 'authorized user' do
    let(:user) { create(:user) }

    before do
      allow(controller).to receive(:authorized_user).and_return(user)
    end

    it 'authorizes a user' do
      expect(controller.authorize).to eq(true)
    end
  end
end
