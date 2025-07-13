require "rails_helper"

RSpec.describe "Test", type: :model do
  it "success" do
    val = true
    expect = true
    expect(val).to be(expect)
  end
end
