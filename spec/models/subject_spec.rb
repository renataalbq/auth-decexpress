require 'rails_helper'

RSpec.describe Subject, type: :model do
  it "is valid with a name and associated teacher" do
    teacher = Teacher.create(name: "João Silva")
    subject = Subject.new(name: "Matematica", teacher: teacher)
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject = Subject.new(teacher: Teacher.new)
    expect(subject).not_to be_valid
  end

  it "is not valid without an associated teacher" do
    subject = Subject.new(name: "Matematica")
    expect(subject).not_to be_valid
  end
end
