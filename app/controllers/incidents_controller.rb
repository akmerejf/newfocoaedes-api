class IncidentsController < ApplicationController
	before_action :set_incident, only: [:show, :destroy, :update]
	before_action :authenticate_request!, except: [:index, :show]
	def index

		if params[:search]
			@incidents = Incident.full_text_search(params[:search])
		else
    		@incidents = Incident.all
		end

		paginate json: @incidents, per_page: 3
	end

	def user_incidents
		@profile = @current_user.profile
		if !params[:search].blank?
			@incidents = Incident.where(profile: @profile).full_text_search(params[:search])
		else
			@incidents = Incident.where(profile: @profile)
		end
		render json: @incidents
	end

	def show
		render json: @incident
	end

	def create
		@incident = Incident.new(incident_params)
		@incident.profile = @current_user.profile
		if @incident.save
		  render json: @incident
		else
		  render json: { errors: @incident.errors }, status: :unprocessable_entity
		end
	end

	def update
   	    if @incident.update_attributes(incident_params)
	      render :show
	    else
	      render json: { errors: { incident: ['not owned by user'] } }, status: :forbidden
	    end
  	end

	def destroy
   	    if @incident.destroy(incident_params)
	      render json: {}
	    else
	      render json: { errors: { incident: ['not owned by user'] } }, status: :forbidden
	    end
  	end

private	
	def set_incident
      @incident = Incident.find(params[:id])
    end

	def incident_params
    	params.permit(:name, :description, images: [:id, :url])
  	end
end