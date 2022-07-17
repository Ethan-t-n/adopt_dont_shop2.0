class PetApplicationsController < ApplicationController
    def create
        pet = Pet.find(params[:pet_id])
        application = Application.find(params[:application_id])
        redirect_to "/applications/#{application.id}"
        PetApplication.create!(pet: pet, application: application)
    end
end
