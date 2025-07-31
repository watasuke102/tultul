class AppController < ApplicationController
  layout "app"
  def dashboard
    @user = Current.user
  end
  def dashboard_edit
    @user = Current.user
  end
  def database
    @user = Current.user
  end
end
