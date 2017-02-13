# frozen_string_literal: true
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/en'
    when /the login page/
      '/en/account/login'
    when /the logout page/
      '/en/account/logout'
    when /the register page/
      '/en/account/register'
    when /the profile edit page for "(.*)"$/
      edit_user_registration_path(User.find_by(email: $1))
    when /the dashboard page/
      dashboard_path(locale: 'en')
    when /the users page/
      users_path(locale: 'en')
    when /the user page for "(.*)"$/
      user_path(User.find_by(email: $1), locale: 'en')
    when /the edit user page for "(.*)"$/
      edit_user_path(User.find_by(email: $1), locale: 'en')
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
