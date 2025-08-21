require "rails_helper"

RSpec.describe CsvParserJob, type: :job do
  it "raise exception if questionnaire not found" do
    expect do
      CsvParserJob.new.perform(128312, "col1,col2")
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "raise exception if csv content is empty" do
    questionnaire = create(:questionnaire)

    expect do
      CsvParserJob.new.perform(questionnaire.id, "")
    end.to raise_error(CSV::MalformedCSVError, /empty/)
  end

  it "parse csv header and create questions record" do
    questionnaire = create(:questionnaire)
    file_content = <<~DOC
      Amount,Note
    DOC

    CsvParserJob.new.perform(questionnaire.id, file_content)

    expect(questionnaire.questions.length).to eq(2)
    expect(questionnaire.submissions.length).to eq(0)
    expect(questionnaire.submission_values.length).to eq(0)
  end

  it "add submission and identify question value type" do
    questionnaire = create(:questionnaire)
    file_content = <<~DOC
      NumCol1,TextCol1,NumCol2,TextCol2
      1,eat,500,chicken
      2,walk,700,legs


      # some weird row incoming
      3,,,
      ,,,
      10
    DOC

    CsvParserJob.new.perform(questionnaire.id, file_content)

    expect(questionnaire.questions.kept.length).to eq(4)
    expect(questionnaire.submissions.length).to eq(4)
    expect(questionnaire.submission_values.length).to eq(10)

    expect(questionnaire.questions.map(&:value_type)).to eq(["number", "text", "number", "text"])
  end
end
