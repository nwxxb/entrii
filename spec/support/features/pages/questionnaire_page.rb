class QuestionnairePage < SitePrism::Page
  set_url "/questionnaires{/id}"

  section :hero, QuestionnaireHeroSection
  element :subnavbar, "#questionnaire-subnavbar"
  section :main_view, "#questionnaire-main-view" do
    section :table, TableSection, "#questionnaire-table" do
      elements :row_actions, "td:has(> button, > a)"
    end
    element :ghost_hint, "#questionnaire-ghost-hint"
  end
end
