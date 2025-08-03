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
      redirect_to questionnaire_path(@questionnaire)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @questionnaire = current_user.questionnaires.find(params[:id])
  end

  private

  def questionnaire_params
    permitted_params = params.require(:questionnaire)
      .permit(
        :title,
        :description,
        questions_attributes: [:name, :description, :value_type, :is_emptyable, :position]
      )

    # TODO: add position input
    permitted_params[:questions_attributes]&.each do |_, question_params|
      question_params.merge!({position: 0})
    end

    permitted_params
  end
end
