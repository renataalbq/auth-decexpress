class Document < ApplicationRecord
    validates :matricula, presence: true
end
