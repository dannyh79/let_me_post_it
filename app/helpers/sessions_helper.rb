module SessionsHelper
  def current_user
    return if not session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def valid_email?
    return true if is_email? && email_is_unique?

    return false
  end
  
  def valid_password?
    return true if password_not_blank? && password_confirmed?

    return false
  end
  
  def is_email?
    return true if params[:user][:email].match(/\A([\w\.%\+\-]+)@([\w\-]+\.)+([a-zA-Z]{2,})\z/i)
    
    @user.errors.add(:email, I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
    return false
  end
  
  def email_is_unique?
    return true if not User.find_by_email(params[:user][:email])
    
    @user.errors.add(:email, I18n.t("activerecord.errors.models.user.attributes.email.not_unique"))
    return false
  end
  
  def password_not_blank?
    return true if params[:user][:password] != ""
    
    @user.errors.add(:password, I18n.t("activerecord.errors.models.user.attributes.password.blank"))
    return false
  end
  
  def password_confirmed?
    return true if params[:user][:password] == params[:user][:password_confirmation]
    
    @user.errors.add(:password, I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation.not_match"))
    return false
  end
end