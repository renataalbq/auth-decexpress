class ChangeDocumentIdToBeOptionalInGrades < ActiveRecord::Migration[7.0]
  def change
    change_column_null :grades, :document_id, true
  end
end
