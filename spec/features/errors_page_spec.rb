require "rails_helper"

RSpec.feature "Errors" do
  ErrorsController::ADDRESSED_ERROR_CODE.each do |http_code_str|
    it "handle #{http_code_str}" do
      visit "/#{http_code_str}"

      expect(page.status_code).to eq(http_code_str.to_i)
      expect(page).to have_content(http_code_str)
    end
  end
end
