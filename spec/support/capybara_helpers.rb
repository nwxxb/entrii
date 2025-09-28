RSpec::Matchers.define :have_link_or_button do |text, **options|
  match do |page|
    disabled = options[:disabled] || false

    if disabled
      page.has_link?(text, href: "#") || page.has_button?(text, disabled: true)
    else
      page.has_link?(text) || page.has_button?(text, disabled: false)
    end
  end

  failure_message do |page|
    state = options[:disabled] ? "disabled" : "enabled"
    "expected that the page/component to have a #{state} link or button with the text: #{text}"
  end

  failure_message_when_negated do |page|
    "expected that the page/component not to have a #{state} link or button with the text: #{text}"
  end
end
