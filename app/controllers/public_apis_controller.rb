class PublicApisController < ApplicationController
  unloadable

  before_filter :require_login, only: [:index, :show]
  before_filter :require_admin

  TABLE_NAMES = ["issues", "projects", "users",
      "time_entries", "news",
      "issue_relations", "versions",
      "wiki_pages", "queries", "issue_statuses",
      "trackers", "enumerations",
      "issue_categories", "roles", "custom_fields"]

  def index
    @table_names = TABLE_NAMES

    if params[:commit].present?
      @api_link = "/public_apis_v1/sql_query/result.#{params[:format_type]}?sql_query=#{URI::encode(params[:sql_query])}"
    end
  end

  def show
    if params[:commit].present?
      conditions = params[:query].present? ? "#{params[:query]}" : "all"
      column_names = params[:column_names].present? ? params[:column_names].join(",") : "*"
      @api_link = "/public_apis_v1/#{params[:table_name]}/#{URI::encode(conditions)}.#{params[:format_type]}?column_names=#{column_names}"
    end

    @table_names = TABLE_NAMES

    @table_name = params[:table_name]

    @model_name = @table_name.classify.constantize
  end
end
