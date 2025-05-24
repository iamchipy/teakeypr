module ApplicationHelper
  def nav_link_to(name, path, tab_name)
    class_name = controller_name == tab_name ? "active" : ""
    link_to name, path, class: class_name
  end
end
