class ShareMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.share_mailer.share.subject
  #
  def share(email, flight_bundle_id)
    @flight_bundle = FlightBundle.find(flight_bundle_id)

    mail(to: email, subject: 'How about this trip with your friend.')   #  "to@example.org"
  end
end
