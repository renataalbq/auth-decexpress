require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(name: 'Renata', email: 'renata@example.com', password: 'password', isAdmin: false)
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = User.new(name: nil)
    expect(user).not_to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(email: nil)
    expect(user).not_to be_valid
  end

  it 'is invalid without a password' do
    user = User.new(password: nil)
    expect(user).not_to be_valid
  end
end
