class ApisController < ApplicationController
  unloadable

  before_filter :require_login, only: [:index, :show, :api]
  before_filter :require_admin

  # accept_rss_auth :api
  # accept_api_auth :api

  def index
    @apis = Api.all.order(:status)
    @api = Api.new
  end

  def create
    @api = Api.new api_params

    if @api.save
      flash[:notice] = "Created successfully."
      redirect_to apis_path
    else
      @apis = Api.all
      render :index
    end
  end

  def edit
    @api = Api.find(params[:id])
  end

  def update
    @api = Api.find(params[:id])
    if @api.update_attributes(api_params)
      flash[:notice] = "Updated successfully."
      redirect_to apis_path
    else
      render :edit
    end
  end

  def destroy
    @api = Api.find(params[:id])
    @api.destroy
    flash[:notice] = "Destroyed successfully."
    redirect_to apis_path
  end

  def update_status
    @api = Api.find(params[:id])
    status = @api.active? ? :inactive : :active
    @api.update_attributes(status: status)
    flash[:notice] = "Updated successfully."
    redirect_to apis_path
  end

  private
  def api_params
    params.require(:api).permit(:name, :endpoint, :description, :query)
  end
end
