class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :search
  
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  require 'csv'

  def after_sign_in_path_for(resource)
    case current_user.role
      when 'admin'
        contacts_path
      when 'silver'
        contacts_path
      when 'gold'
        contacts_path
      when 'platinum'
        contacts_path
      else
        root_path
    end
  end
  
  def index
    @search = Contact.search(params[:q])
    @contacts = @search.result(distinct: true).paginate(page: params[:page], per_page: 25)
  end
  
  private
  
  def search
    if params[:search]
      search_params = CGI::escapeHTML(params[:search]) 
      redirect_to ("/contacts?utf8=%E2%9C%93&search=#{search_params}")
    end
  end  

end
