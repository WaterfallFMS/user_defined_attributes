class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_current_user
  before_filter :set_current_tenant
  helper_method :current_tenant, :current_user

  private

  def set_current_user
    @user = User.first
  end

  def set_current_tenant
    @tenant = Tenant.new.save
  end

  def current_user
    @user
  end

  def current_tenant
    @tenant
  end

  # for policy stuff
  def policy_scope(object)
    object
  end

  def authorize(object,action=nil)
    true
  end
end
