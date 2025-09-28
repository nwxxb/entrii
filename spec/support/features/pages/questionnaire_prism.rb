class QuestionnairePrism
  def main
    QuestionnairePage.new
  end

  def edit_questions
    QuestionnaireEditQuestionsPage.new
  end

  def add_submission
    QuestionnaireAddSubmissionPage.new
  end
end
