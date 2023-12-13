require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it "is valid with a name" do
    teacher = Teacher.new(name: "João Silva")
    expect(teacher).to be_valid
  end

  it "is not valid without a name" do
    teacher = Teacher.new
    expect(teacher).not_to be_valid
  end
end
