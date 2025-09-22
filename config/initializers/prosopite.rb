if defined? Prosopite
  unless Rails.env.production?
    require "prosopite/middleware/rack"
    Rails.configuration.middleware.use(Prosopite::Middleware::Rack)
  end

  Prosopite.enabled = true
  Prosopite.rails_logger = true
end
