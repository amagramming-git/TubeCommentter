class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout 'mailer'
  add_template_helper(ApplicationHelper)
end
