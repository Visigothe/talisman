class User::ConfirmationsController < Devise::ConfirmationsController

	def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      set_flash_message(:error, :already_confirmed)
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ redirect_to new_user_session_path }
    end
  end

	protected

		def after_resending_confirmation_instructions_path_for(resource)
			root_path
		end
end