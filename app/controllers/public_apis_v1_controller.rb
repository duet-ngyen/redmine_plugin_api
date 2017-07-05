class PublicApisV1Controller < ApplicationController
  unloadable

  before_filter :require_login, only: [:api]
  before_filter :require_admin

  accept_rss_auth :api
  accept_api_auth :api

  def api
    if params[:sql_query].present?
      query = params[:sql_query]
    else
      conditions = (params[:conditions] != "all") ? "where #{params[:conditions]}" : ""
      query = "select #{params[:column_names]} from #{params[:table_name]} #{conditions}"
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
  # result = params[:table_name].classify.constantize.find_by_sql(query)

    respond_to do |format|
      format.json{ render json: result.as_json }
      format.xml{ render xml: result.as_json }
    end
  end
end
