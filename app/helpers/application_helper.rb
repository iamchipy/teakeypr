# app/helpers/application_helper.rb
module ApplicationHelper
  def nav_link_to(name, path, controller:, action: nil)
    current_controller = controller_name
    current_action = action_name

    is_active =
      if action
        current_controller == controller && current_action == action
      else
        current_controller == controller && current_action == "index"
      end

    class_name = is_active ? "active" : ""
    link_to name, path, class: class_name
  end
end
