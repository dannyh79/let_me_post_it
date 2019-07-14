class Admin::BaseController < ApplicationController
  include SessionsHelper

  before_action :require_login
  before_action :authenticate_user!
end