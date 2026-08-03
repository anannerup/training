class SettingsController < ApplicationController
  def edit
  end

  def profile
    if Current.user.update(profile_params)
      redirect_to edit_settings_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def password
    if Current.user.authenticate(params.dig(:user, :current_password))
      if Current.user.update(password_params)
        redirect_to edit_settings_path, notice: "Password updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      Current.user.errors.add(:current_password, "is incorrect")
      render :edit, status: :unprocessable_entity
    end
  end

  def preferences
    if Current.user.update(preferences_params)
      redirect_to edit_settings_path, notice: "Preferences updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def profile_params
      params.expect(user: [ :email_address ])
    end

    def password_params
      params.expect(user: [ :password, :password_confirmation ])
    end

    def preferences_params
      params.expect(user: [ :time_zone ])
    end
end
