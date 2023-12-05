class Document < ApplicationRecord
    validates :matricula, presence: true
    has_many :grades
end
