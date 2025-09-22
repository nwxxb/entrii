if ENV["PROFILE_CONTROLLER_OUTPUT_FILENAME"]
  PROFILE_LOGGER = ActiveSupport::Logger.new("log/#{ENV["PROFILE_CONTROLLER_OUTPUT_FILENAME"]}")
  PROFILE_LOGGER.info(
    "event_id\tcontroller\taction\tparams\tmethod\tpath\tstatus\tview_runtime\tdb_runtime\tview_and_db_total\tevent_duration"
  )

  ActiveSupport::Notifications.subscribe("process_action.action_controller") do |name, start, finish, unique_id, data|
    event_duration = (finish - start) * 1000
    view_runtime = data[:view_runtime] || 0
    db_runtime = data[:db_runtime] || 0
    view_and_db_total = view_runtime + db_runtime

    row_str = [
      unique_id,
      data[:controller],
      data[:action],
      "\"#{data[:params].to_json}\"",
      data[:method],
      data[:path],
      data[:status],
      view_runtime,
      db_runtime,
      view_and_db_total,
      event_duration
    ]
    PROFILE_LOGGER.info(row_str.join("\t"))
  end
end
