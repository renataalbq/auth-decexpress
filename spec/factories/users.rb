FactoryBot.define do
    factory :user do
      name { 'Renata Albuquerque' }
      email { 'renataalbq@email.com' }
      password { 'password' }
      isAdmin { false }
    end
end