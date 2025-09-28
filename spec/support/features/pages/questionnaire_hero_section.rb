class QuestionnaireHeroSection < SitePrism::Section
  set_default_search_arguments "#questionnaire-hero"

  element :heading, "#questionnaire-hero>h1"
  element :description, "#questionnaire-hero>p"
end
