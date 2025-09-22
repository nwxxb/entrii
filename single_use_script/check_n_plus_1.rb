require "database_cleaner/active_record"
require "benchmark/ips"

unless Rails.env.local_prod?
  puts "hmm... I don't think you use the correct environment: #{Rails.env}"
  exit
end

begin
  DatabaseCleaner.strategy = :truncation

  Rails.logger.debug("DatabaseCleaner: starting...")
  DatabaseCleaner.start

  current_user = FactoryBot.create(:user, email: "tonjekk@mantep.com")
  questionnaire = FactoryBot.create(:questionnaire, user: current_user)
  FactoryBot.create_list(:submission_value, 25, questionnaire: questionnaire)

  Benchmark.ips do |x|
    x.config(warmup: 2, time: 5)

    x.report("without any includes") do
      parent_record = current_user.questionnaires.find(questionnaire.id)
      parent_record.submissions.each do |s|
        s.whole_submission_values
      end
    end

    x.report("includes all questionnaire sub-resources") do
      parent_record = current_user.questionnaires.includes(:questions, submissions: [:kept_questions, :submission_values]).find(questionnaire.id)
      parent_record.submissions.each do |s|
        s.whole_submission_values
      end
    end

    x.compare!
  end
ensure
  Rails.logger.debug("DatabaseCleaner: cleaning...")
  DatabaseCleaner.clean
end
