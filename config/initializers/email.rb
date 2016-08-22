if Rails.env.production?
  email_yml = YAML::load(File.open(Rails.root + 'config/email.yml'))
  ActionMailer::Base.delivery_method = email_yml[:delivery_method]
  ActionMailer::Base.smtp_settings = email_yml[:smtp_settings]
end
