require "rails_helper"

RSpec.feature "Questionnaire (Upload CSV)", :js do
  it "user can create new questionnaire" do
    user = create(:user)
    questionnaire = create(:questionnaire, user: user)
    file_content = <<~DOC
      Amount,Note
      2000,snack
      ,free shoes
      1000,
    DOC

    sign_in(user)

    visit questionnaire_path(questionnaire)

    first("button, a", text: "upload csv").click

    within("form[action='#{questionnaire_csv_create_path(questionnaire)}']") do
      with_temp_file("spending.csv", file_content) do |f|
        attach_file f.path do
          find("#questionnaire_csv_file", visible: :all).click
        end

        expect(page).to have_content(File.basename(f.path))
        find("[type='submit']").click
      end
    end

    expect(page).to have_current_path(questionnaire_path(questionnaire))
    expect(page).not_to have_selector("button, a", text: "upload csv", visible: true)
    expect(page).to have_table(with_rows: [
      {"Amount" => "2000", "Note" => "snack"},
      {"Amount" => "", "Note" => "free shoes"},
      {"Amount" => "1000", "Note" => ""}
    ])
  end

  def with_temp_file(filename, content)
    f = Tempfile.new(filename, Rails.root.join("spec/fixtures/files/"))
    f.write content
    f.rewind

    yield(f)
  ensure
    if f
      f.close
      f.unlink
    end
  end
end
