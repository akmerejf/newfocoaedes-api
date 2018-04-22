class ProfilesController < ApplicationController
	before_action :authenticate_request!
	before_action :set_profile, except: [:create]


	def show
		render json: @profile
	end

	def create
		@profile = Profile.new(profile_params)
		if @profile.save
			render :show
		else
		  	render json: { errors: @profile.errors }, status: :unprocessable_entity
		end
	end

	def update
   	    if @profile.update_attributes(profile_params)
	      render :show
	    else
	      render json: { errors: { item: ['not owned by user'] } }, status: :forbidden
	    end
  	end

	def destroy
   	    if @profile.destroy(profile_params)
	      render json: {}
	    else
	      render json: { errors: { item: ['not owned by user'] } }, status: :forbidden
	    end
  	end

	private	

	def set_profile
		@profile = Profile.find_by(user: @current_user)
	end

	def profile_params
    	params.permit(:name, :phone, :user_id)
  	end
end
