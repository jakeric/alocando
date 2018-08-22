class ShareController < ApplicationController
  skip_before_action :authenticate_user!
  def share
    email = share_params["email"]
    friends_email = share_params["friends-email"]
    message = share_params["message"]
    url = share_params["url"]
    flight_bundle_id = share_params["flight_bundle_id"]


    ShareMailer.share(email, flight_bundle_id, url, message).deliver_now if (email =~ /\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b/) == 0
    ShareMailer.share(friends_email, flight_bundle_id, url, message).deliver_now if (friends_email =~ /\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b/) == 0
    redirect_back(fallback_location: home_path)
  end

  private

  def share_params
    params.permit("email", "flight_bundle_id", "url", "friends-email", "message")
  end

end
