class Teacher < ApplicationRecord
    has_many :subjects, dependent: :destroy
    validates :name, presence: true
end
