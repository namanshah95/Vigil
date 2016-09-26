class DangerZoneController < ApplicationController

  def index
    danger_zones = DangerZone.around(latitude: params[:latitude], longitude: params[:longitude], radius: params[:radius])

    respond_to do |format|
      format.json do
        render json: danger_zones.to_json
      end
    end
  end

end