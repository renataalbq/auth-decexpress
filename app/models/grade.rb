class Grade < ApplicationRecord
    belongs_to :document, optional: true
end
