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

  def create_from_csv
    @questionnaire = Questionnaire.find(params[:questionnaire_id])

    begin
      CsvParserJob.new.perform(@questionnaire.id, params[:csv_file].tempfile.read)
    rescue CSV::MalformedCSVError => e
      redirect_to(questionnaire_path(@questionnaire), alert: "Can't parse document: #{e.message}") and return
    rescue ActiveRecord::ActiveRecordError => e
      redirect_to(questionnaire_path(@questionnaire), alert: "#{e.message}") and return
    end

    redirect_to(questionnaire_path(@questionnaire)) and return
  end

  private

  def questionnaire_params
    params.require(:questionnaire)
      .permit(
        :title,
        :description
      )
  end
end
