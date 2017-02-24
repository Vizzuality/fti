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
      root_path(locale: I18n.locale)
    when /the login page/
      new_user_session_path(locale: I18n.locale)
    when /the register page/
      new_user_registration_path(locale: I18n.locale)
    when /the profile edit page for "(.*)"$/
      edit_user_registration_path(User.find_by(email: $1))
    when /the dashboard page/
      dashboard_path(locale: I18n.locale)
    when /the users page/
      users_path(locale: I18n.locale)
    when /the user page for "(.*)"$/
      user_path(User.find_by(email: $1), locale: I18n.locale)
    when /the edit user page for "(.*)"$/
      edit_user_path(User.find_by(email: $1), locale: I18n.locale)
    when /the countries page/
      countries_path(locale: I18n.locale)
    when /the country page for "(.*)"$/
      country_path(Country.find_by(name: $1), locale: I18n.locale)
    when /the edit country page for "(.*)"$/
      edit_country_path(Country.find_by(name: $1), locale: I18n.locale)
    when /the new country page/
      new_country_path(locale: I18n.locale)
    when /the species page/
      species_index_path(locale: I18n.locale)
    when /the species page for "(.*)"$/
      species_path(Species.find_by(name: $1), locale: I18n.locale)
    when /the edit species page for "(.*)"$/
      edit_species_path(Species.find_by(name: $1), locale: I18n.locale)
    when /the new species page/
      new_species_path(locale: I18n.locale)
    when /the operators page/
      operators_path(locale: I18n.locale)
    when /the operator page for "(.*)"$/
      operator_path(Operator.find_by(name: $1), locale: I18n.locale)
    when /the edit operator page for "(.*)"$/
      edit_operator_path(Operator.find_by(name: $1), locale: I18n.locale)
    when /the new operator page/
      new_operator_path(locale: I18n.locale)
    when /the monitors page/
      monitors_path(locale: I18n.locale)
    when /the monitor page for "(.*)"$/
      monitor_path(Observer.find_by(name: $1), locale: I18n.locale)
    when /the edit monitor page for "(.*)"$/
      edit_monitor_path(Observer.find_by(name: $1), locale: I18n.locale)
    when /the new monitor page/
      new_monitor_path(locale: I18n.locale)
    when /the categories page/
      categories_path(locale: I18n.locale)
    when /the category page for "(.*)"$/
      category_path(Category.find_by(name: $1), locale: I18n.locale)
    when /the edit category page for "(.*)"$/
      edit_category_path(Category.find_by(name: $1), locale: I18n.locale)
    when /the new category page/
      new_category_path(locale: I18n.locale)
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
