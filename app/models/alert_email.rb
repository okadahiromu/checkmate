class AlertEmail < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  def create
    @alert_email = current_user.sent_alert_emails.build(alert_email_params)
    if @alert_email.save
      # アラートメールを保存し、送信するロジック
      send_alert_email(@alert_email)
      redirect_to alert_emails_path, notice: 'アラートメールを送信しました'
    else
      render :new
    end
  end

  # ...

  private

  def send_alert_email(alert_email)
    # アラートメールを送信するコードをここに追加
  end

  def alert_email_params
    params.require(:alert_email).permit(:title, :body, :recipient_id, :status)
  end
end
