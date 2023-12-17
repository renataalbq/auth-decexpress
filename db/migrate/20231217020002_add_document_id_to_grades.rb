class AddDocumentIdToGrades < ActiveRecord::Migration[7.0]
  def change
    add_reference :grades, :document, null: false, foreign_key: true
  end
end
