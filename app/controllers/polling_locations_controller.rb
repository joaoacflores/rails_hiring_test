class PollingLocationsController < ApplicationController
  # POST /polling_locations or /polling_locations.json
  def create
    @polling_location = PollingLocation.create(polling_location_params)

    if @polling_location.save
      redirect_to @polling_location.riding, notice: 'Polling location was successfully created.'
    else
      @riding = @polling_location.riding
      render 'ridings/edit', status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_polling_location
      @polling_location = PollingLocation.includes(:polls).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def polling_location_params
      params.require(:polling_location).permit(:id, :title, :address, :city, :postal_code, :polls_list, :riding_id)
    end
end
