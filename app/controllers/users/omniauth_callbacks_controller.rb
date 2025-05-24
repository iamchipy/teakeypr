# app/controllers/users/omniauth_callbacks_controller.rb:

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
        sign_in_and_redirect @user, event: :authentication
      else
        # Useful for debugging login failures. Uncomment for development.
        # session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
  end

  def discord
    # store the hash we got from current auth
    current_hash = request.env["omniauth.auth"]

    # convert that hash into a user (making one if it's new)
    @user = User.from_omniauth(current_hash)

    # check if user already exists
    if @user.persisted?
      # if so we update the saved_hash with current
      @user.update_omniauth_hashes(current_hash)

      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Discord"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.discord_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
