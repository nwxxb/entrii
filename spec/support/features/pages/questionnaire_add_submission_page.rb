class QuestionnaireAddSubmissionPage < SitePrism::Page
  set_url "/questionnaires{/id}/submissions/new"

  section :hero, QuestionnaireHeroSection
  element :subnavbar, "#questionnaire-subnavbar"
  section :main_view, "#questionnaire-main-view" do
    sections :question_fields, "fieldset" do
      element :question_label, "label"
      element :question_field, "input"
    end
    element :submit_btn, "input[type='submit']"
  end

  def question_labels_text
    main_view.question_fields.map(&:text)
  end
end
