# frozen_string_literal: true
module RoutesHelper
  def common_form?
    request_path  = (request.path.include?('/edit') || request.path.include?('/new'))
    action_method = controller.action_name.include?('create') || controller.action_name.include?('update')
    request_path || action_method ? false : true
  end
end
