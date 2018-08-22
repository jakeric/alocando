# Preview all emails at http://localhost:3000/rails/mailers/share_mailer
class ShareMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/share_mailer/share
  def share
    ShareMailer.share
  end

end
