class AlertEmailsController < ApplicationController
  before_action :authenticate_user! # ログイン認証が必要

  def index
    sent_alert_emails = current_user.sent_alert_emails
  
    if sent_alert_emails
      @sent_alert_emails = sent_alert_emails
    else
      @sent_alert_emails = []
    end
  
    @received_alert_emails = current_user.received_alert_emails
  end

  def show
    @alert_email = current_user.alert_emails.find(params[:id])
  end

  def new
    @alert_email = current_user.sent_alert_emails.build
  end

  def create
    @alert_email = current_user.sent_alert_emails.build(alert_email_params)
    @alert_email.sent_at = Time.now # 現在の時間を設定
  
    if @alert_email.save
      # メール送信のロジックが成功した場合、statusを更新
      @alert_email.update(status: 'sent')
      AlertMailer.send_alert(@alert_email).deliver_now
      redirect_to alert_emails_path
    else
      render :new
    end
  end
  

  def edit
    @alert_email = current_user.sent_alert_emails.find(params[:id])
  end

  def update
    @alert_email = current_user.sent_alert_emails.find(params[:id])
    if @alert_email.update(alert_email_params)
      redirect_to alert_emails_path, notice: 'アラートメールを更新しました'
    else
      Rails.logger.error @alert_email.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @alert_email = current_user.sent_alert_emails.find(params[:id])
    @alert_email.destroy
    redirect_to alert_emails_path, notice: 'アラートメールを削除しました'
  end

  private

  def alert_email_params
    params.require(:alert_email).permit(:title, :body, :recipient_id, :sender_id, :status)
  end
end
