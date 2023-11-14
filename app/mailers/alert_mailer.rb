class AlertMailer < ApplicationMailer
  def send_alert(alert_email)
    @alert_email = alert_email
    @item = alert_email.item
    @user = alert_email.recipient
    mail(to: @user.email, subject: 'アラートメール')
  end
end
