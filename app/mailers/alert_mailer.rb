class AlertMailer < ApplicationMailer
  def send_alert(item)
    @item = item
    user = item.list.user
    mail(to: user.email, subject: 'アイテムのアラート')
  end
end
