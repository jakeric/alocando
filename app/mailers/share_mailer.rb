class ShareMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.share_mailer.share.subject
  #
  def share(email, flight_bundle_id, url, message)
    @flight_bundle = FlightBundle.find(flight_bundle_id)
    @url = url
    @message = message

    mail(to: email, subject: 'A friend shared a trip with you')   #  "to@example.org"
  end
end
