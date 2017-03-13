# frozen_string_literal: true
When /^I reload the page$/ do
  Capybara.current_session.evaluate_script('window.location.reload()');
end
