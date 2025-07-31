class QuestionsController < ApplicationController
  def show
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
  end

  def edit
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
  end

  def update
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
    if @questionnaire.update(questions_params)
      redirect_to questionnaire_path(@questionnaire)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def questions_params
    permitted_params = params.require(:questionnaire)
      .permit(
        questions_attributes: [:id, :name, :description, :value_type, :is_emptyable, :position, :_destroy]
      )

    # TODO: add position input
    permitted_params[:questions_attributes]&.each do |_, question_params|
      question_params.merge!({position: 0})
    end

    permitted_params
  end
end
