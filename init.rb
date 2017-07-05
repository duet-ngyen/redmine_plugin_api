Redmine::Plugin.register :public_api do
  name 'Public Api plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  require 'admin_menu_hooks'

  menu :admin_menu, :public_api_v1, { :controller => 'public_apis', :action => 'index' }, :caption => 'API by sql'
  menu :admin_menu, :public_api_v2, { :controller => 'apis', :action => 'index' }, :caption => 'API by endpoint'
end
