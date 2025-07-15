require "rails_helper"

RSpec.feature "Auth", :js do
  it "user can sign in & sign out" do
    password = "password"
    user = create(:user, password: password)

    visit root_path
    find("button, a", text: "sign in").click

    expect(page).to have_current_path(new_user_session_path)

    within("form[action='#{new_user_session_path}']") do
      fill_in "user_email", with: user.email
      fill_in "user_password", with: password

      find("[type='submit']").click
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_selector("button, a", text: "sign out").or(
      have_selector("input#user_sign_out[type='submit']")
    )

    find("input#user_sign_out[type='submit']").click

    expect(page).to have_current_path(root_path)
    expect(page).to have_selector("button, a", text: "sign in")
  end

  it "user can register" do
    password = "password"
    user = build(:user, password: password)

    visit root_path
    find("button, a", text: "sign up").click

    expect(page).to have_current_path(new_user_registration_path)

    within("form[action='#{user_registration_path}']") do
      fill_in "user_email", with: user.email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password

      find("[type='submit']").click
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_selector("button, a", text: "sign out").or(
      have_selector("input#user_sign_out[type='submit']")
    )
  end

  it "user can update it's email and password" do
    new_email = "new@example.com"
    new_password = "new_password"
    user = create(:user)

    sign_in(user)
    visit root_path
    find("button, a", text: "profile").click

    expect(page).to have_content(user.email)

    find("button, a", text: "edit").click

    expect(page).to have_current_path(edit_user_registration_path)

    within("form#edit_user[action='#{user_registration_path}']") do
      fill_in "user_email", with: new_email
      fill_in "user_password", with: new_password
      fill_in "user_password_confirmation", with: new_password
      fill_in "user_current_password", with: user.password

      find("[type='submit']").click
    end

    expect(page).to have_current_path(root_path)
    user.reload
    expect(user.email).to eq(new_email)
    expect(user.valid_password?(new_password)).to be(true)
  end

  it "user can forget it's password" do
    new_password = "new_password"
    user = create(:user)

    visit new_user_session_path
    find("button, a", text: "forgot your password?").click

    expect(page).to have_current_path(new_user_password_path)

    within("form[action='#{user_password_path}']") do
      fill_in "user_email", with: user.email

      find("[type='submit']").click
    end

    user.reload
    email_body = ActionMailer::Base.deliveries.last.body.to_s
    hashed_token = email_body.match(/reset_password_token=([^&\s]+)">/)[1]
    visit edit_user_password_path(reset_password_token: hashed_token)

    within("form[action='#{user_password_path}']") do
      fill_in "user_password", with: new_password
      fill_in "user_password_confirmation", with: new_password

      find("[type='submit']").click
    end

    user.reload
    expect(user.valid_password?(new_password)).to be(true)
  end

  it "user can destroy it's user data" do
    user = create(:user)

    sign_in(user)
    visit root_path
    find("button, a", text: "profile").click

    expect(page).to have_content(user.email)

    find("button, a", text: "edit").click

    expect(page).to have_current_path(edit_user_registration_path)

    find("input#user_destroy[type='submit']").click

    expect(page).to have_current_path(root_path)
    expect(User.find_by(id: user.id).blank?).to be(true)
  end
end
