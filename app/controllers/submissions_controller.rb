class SubmissionsController < ApplicationController
  def new
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])

    @questions = @questionnaire.questions.kept

    if @questions.blank?
      redirect_to(questionnaire_path(@questionnaire), alert: "current questionnaire doesn't have any questions yet") and return
    end

    @old_submission = nil
    if prefill_with_prev_submission_params
      @old_submission = @questionnaire.submissions.last
    end

    @submission = @questionnaire.submissions.new
    @questionnaire.questions.kept.each do |question|
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

  def destroy
    @questionnaire = current_user.questionnaires.find(params[:questionnaire_id])
    @submission = @questionnaire.submissions.find(params[:id])

    @submission.destroy!
    redirect_to questionnaire_path(@questionnaire)
  end

  private

  def prefill_with_prev_submission_params
    ActiveRecord::Type::Boolean.new.cast(params[:prefill_with_prev_submission])
  end

  def submission_params
    params.require(:submission)
      .permit(submission_values_attributes: [:id, :question_id, :value])
  end
end
