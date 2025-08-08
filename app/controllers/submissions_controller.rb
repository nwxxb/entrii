class SubmissionsController < ApplicationController
  def new
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
    @submission = @questionnaire.submissions.new
    @questionnaire.questions.each do |question|
      @submission.submission_values.new(question: question)
    end
  end

  def create
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
    @submission = @questionnaire.submissions.new(submission_params)

    if @submission.save
      redirect_to questionnaire_path(@questionnaire)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
    @submission = @questionnaire.submissions.find(params[:id])
  end

  def update
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
    @submission = @questionnaire.submissions.find(params[:id])

    if @submission.update(submission_params)
      redirect_to questionnaire_path(@questionnaire)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def submission_params
    params.require(:submission)
      .permit(submission_values_attributes: [:question_id, :value])
  end
end
