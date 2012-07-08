class User::ConfirmationsController < Devise::ConfirmationsController

	protected

		def after_resending_confirmation_instructions_path_for(resource)
			root_path
		end
end