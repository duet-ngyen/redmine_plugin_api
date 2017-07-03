class AdminMenuHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    stylesheet_link_tag('public_api.css', :plugin => 'public_api')
  end
end
