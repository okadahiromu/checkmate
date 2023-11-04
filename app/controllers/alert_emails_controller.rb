class AlertEmailsController < ApplicationController
  before_action :authenticate_user! # ログイン認証が必要

  def index
    @sent_alert_emails = current_user.sent_alert_emails
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
    if @alert_email.save
      redirect_to alert_emails_path, notice: 'アラートメールを送信しました'
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
    params.require(:alert_email).permit(:title, :body, :recipient_id, :status)
  end
end
