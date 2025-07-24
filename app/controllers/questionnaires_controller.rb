class QuestionnairesController < ApplicationController
  before_action :authenticate_user!

  def index
    @questionnaires = current_user.questionnaires
  end

  def new
    @questionnaire = Questionnaire.new
  end

  def create
    @questionnaire = current_user.questionnaires.new(questionnaire_params)

    if @questionnaire.save
      redirect_to questionnaires_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def questionnaire_params
    params.require(:questionnaire).permit(:title, :description)
  end
end
