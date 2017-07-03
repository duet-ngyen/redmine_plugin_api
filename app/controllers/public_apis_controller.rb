class PublicApisController < ApplicationController
  unloadable

  before_filter :require_login, only: [:index, :show, :api]
  before_filter :require_admin

  accept_rss_auth :api
  accept_api_auth :api

  TABLE_NAMES = ["issues", "projects", "users",
      "time_entries", "news",
      "issue_relations", "versions",
      "wiki_pages", "queries", "issue_statuses",
      "trackers", "enumerations",
      "issue_categories", "roles", "custom_fields"]

  def index
    @table_names = TABLE_NAMES

    if params[:commit].present?
      @api_link = "/public_apis/sql_query/result.#{params[:format_type]}?sql_query=#{URI::encode(params[:sql_query])}"
    end
  end

  def show
    if params[:commit].present?
      conditions = params[:query].present? ? "#{params[:query]}" : "all"
      column_names = params[:column_names].present? ? params[:column_names].join(",") : "*"
      @api_link = "/public_apis/#{params[:table_name]}/#{URI::encode(conditions)}.#{params[:format_type]}?column_names=#{column_names}"
    end

    @table_names = TABLE_NAMES

    @table_name = params[:table_name]

    @model_name = @table_name.classify.constantize
  end

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
