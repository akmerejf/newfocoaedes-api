class PasswordsController < ApplicationController
	def forgot
	    if params[:email].blank?
	      return render json: {error: 'Email not present'}
	    end

	    user = User.find_by(email: params[:email].downcase)

	    if user.present? && user.confirmed_at?
	    	user.generate_password_code!
	    	UserMailer.reset_password(user).deliver
	    	render json: {status: 'ok'}, status: :ok
	    else
	      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
	    end
  	end

  	

	def reset
		code = params[:code].to_s

		if params[:code].blank?
			return render json: {error: 'Code not present'}
		end

		user = User.find_by(reset_password_code: code)

		if user.present? && user.password_code_valid?
			if user.reset_password!(params[:password])
				render json: {status: 'ok'}, status: :ok
			else
				render json: {error: user.errors.full_messages}, status: :unprocessable_entity
			end
		else
			render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
		end
	end

	def update
		if !params[:password].present?
			render json: {error: 'Password not present'}, status: :unprocessable_entity
			return
		end

		if current_user.reset_password(params[:password])
			render json: {status: 'ok'}, status: :ok
		else
			render json: {errors: current_user.errors.full_messages}, status: :unprocessable_entity
		end
	end

end
