desc "Send request emails to guests checking in soon..."

task send_emails: :environment do 
  SendRequestEmailsJob.perform_now 
end
