class ApplicationController < ActionController::Base

  private

  def paginate_per
    session[:paginate_per] = params[:per] if params[:per].present?
    session[:paginate_per]
  end

  def keep_last_pagination_data
    session[:last_pagination_data] = {
      params: request.query_parameters,
      controller: controller_name,
      action: action_name
    }
  end

  def load_pagination_params(action)
    data = session[:last_pagination_data].presence
    if data["controller"] == controller_name && data["action"] == action.to_s
      session[:last_pagination_data] = nil
      ret = data["params"]
    end
  end

  def redirect_with_kept_pagination_params(action:, **args)
    redirect_to({ action: action, params: load_pagination_params(action) }, args)
  end
end
