class AddDocumentToGrades < ActiveRecord::Migration[7.0]
  def change
    add_reference :grades, :document, null: true, foreign_key: true
  end
end
