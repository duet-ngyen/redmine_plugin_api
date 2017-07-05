class PublicApisV2Controller < ApplicationController
  unloadable

  before_filter :api_require_login, only: :api
  before_filter :api_require_admin, only: :api

  accept_rss_auth :api
  accept_api_auth :api

  def api
    api = Api.find_by(endpoint: params[:endpoint])
    if api.inactive?
      render json: {messages: "This api is not active now, contact admin to active it."}
      return true
    end

    format_type = params[:format_type]

    query_params = api.get_params_from_query
    query = api.query.strip

    query_params.each do |p|
      if params[p].present?
        query = query.gsub(":#{p}", params[p])
      else
        render json: {messages: "Invalid params. Accepted params only: #{query_params.join(', ')}"}
        return true
      end
    end

    if query.downcase.start_with?('select')
      begin
        result = ActiveRecord::Base.connection.exec_query(query)
      rescue ActiveRecord::StatementInvalid => msg
        result = {error_message: msg.message}
      rescue Exception => msg
        result = {error_message: msg.message}
      end
    else
      result = {error_message: "Invalid query."}
    end

    case params[:format_type]
    when "json"
      render json: result.as_json
    when "xml"
      render xml: result.as_json
    else
      render json: {errors: "Invalid Format"}
    end
  end

  private

  def api_require_login
    if !User.current.logged?
      if request.get?
        url = url_for(params)
      else
        url = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id], :project_id => params[:project_id])
      end
      case params[:format_type]
      when "json"
        render json: {errors: "You have not loged in yet."}
      when "xml"
        render xml: {errors: "You have not loged in yet."}
      else
        render json: {errors: "Invalid Format"}
      end

      return false
    end
    return true
  end

  def api_require_admin
    return unless api_require_login
    if !User.current.admin?
      case params[:format_type]
      when "json"
        render json: {errors: "You are not authorized to access this data."}
      when "xml"
        render xml: {errors: "You are not authorized to access this data."}
      else
        render json: {errors: "Invalid Format"}
      end
      return false
    end
    true
  end
end
