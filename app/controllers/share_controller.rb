class ShareController < ApplicationController
  skip_before_action :authenticate_user!
  def share
    email = share_params["email"]
    flight_bundle_id = share_params["flight_bundle_id"]
    ShareMailer.share(email, flight_bundle_id).deliver_now
    redirect_back(fallback_location: home_path)
  end

  private

  def share_params
    params.permit("email", "flight_bundle_id")
  end

end
