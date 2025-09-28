class QuestionnaireEditQuestionsPage < SitePrism::Page
  set_url "/questionnaires{/id}/questions/edit"

  section :hero, QuestionnaireHeroSection
  element :subnavbar, "#questionnaire-subnavbar"
  section :main_view, "#questionnaire-main-view" do
    section :question_form_actionbar, "#question-form-actionbar" do
      element :add_question_btn, %(button[data-behaviour="add-question-form"])
      element :preview_btn, %(button[data-behaviour="show-questions-preview"])
    end
    section :question_form_cards_wrapper, "#question-form-cards-wrapper" do
      sections :question_form_cards, ".card.question-form" do
        element :name_field, %(input[name^="questionnaire[questions_attributes]"][name$="[name]"])
        element :description_field, %(input[name^="questionnaire[questions_attributes]"][name$="[description]"])
        element :value_type_field, %(select[name^="questionnaire[questions_attributes]"][name$="[value_type]"])
        element :is_emptyable_field, %(input[name^="questionnaire[questions_attributes]"][name$="[is_emptyable]"])
        element :remove_btn, %(button[data-behaviour="remove-question-form"])
        element :move_up_btn, %(button[data-behaviour="change-question-position-up"])
        element :move_down_btn, %(button[data-behaviour="change-question-position-down"])
      end
    end
    element :submit_btn, "input[type='submit']"
    element :ghost_hint, " #questionnaire-ghost-hint"
  end
  element :preview_modal, "#questions-preview-modal"
end
