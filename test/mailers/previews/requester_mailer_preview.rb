# Preview all emails at http://localhost:3000/rails/mailers/requester_mailer
class RequesterMailerPreview < ActionMailer::Preview

  def id_email
    RequesterMailer.id_email
  end

end