require "rails_helper"

RSpec.describe User, type: :model do
  it "rejects wrong file for avatar" do
    user = create(:user)

    user.avatar.attach(io: StringIO.new("a dummy invalid image"), filename: "an_invalid_image")
    user.save

    expect(user.errors.blank?).to be(false)

    user.reload
    expect(user.avatar.attached?).to be(false)
    expect(user.avatar.blank?).to be(true)
  end

  it "accepts valid image for avatar" do
    user = create(:user)
    tiny_transparent_image = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
    binary_data = Base64.decode64(tiny_transparent_image)

    user.avatar.attach(io: StringIO.new(binary_data), filename: "an_invalid_image")
    user.save

    expect(user.errors.blank?).to be(true)

    user.reload
    expect(user.avatar.image?).to be(true)
    expect(user.avatar.attached?).to be(true)
    expect(user.avatar.blank?).to be(false)
  end
end
