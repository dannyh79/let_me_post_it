class Admin::BackendController < ApplicationController
  before_action :require_login

  def index
  end
end