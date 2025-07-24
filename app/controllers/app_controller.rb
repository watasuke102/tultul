class AppController < ApplicationController
  layout "app"
  def dashboard
    @user = Current.user
  end
end
