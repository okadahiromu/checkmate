class ItemsController < ApplicationController
  before_action :authenticate_user! # ログイン認証が必要

  def index
    @list = current_list # @list を設定する
    @items = @list.items
  end

  def new
    @list = List.find(params[:list_id])
    @item = @list.items.build
  end

  def create
    @list = List.find(params[:list_id])
    @item = @list.items.build(item_params)
    if @item.save
      redirect_to list_items_path, notice: 'アイテムを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @item = current_list.items.find(params[:id])
    if @item.update(checked: !@item.checked)
      if all_items_checked? || overdue_condition_met?
        alert_email = create_alert_email(@item)
        AlertMailer.send_alert(alert_email).deliver_now
      end
  
      redirect_to list_items_path(current_list)
    else
      render :edit
    end
  end

  def destroy
    @list = List.find(params[:list_id])
    @item = @list.items.find(params[:id])
    
    if @item.destroy
      redirect_to list_items_path(@list), notice: 'アイテムを削除しました'
    else
      redirect_to list_items_path(@list), alert: 'アイテムの削除に失敗しました'
    end
  end
  

  private

  def current_list
    @current_list ||= current_user.lists.find(params[:list_id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :checked)
  end

  def all_items_checked?
    all_items = current_list.items
    all_checked = all_items.all? { |item| item.checked }
    return all_checked && all_items.present?
  end

  def overdue_condition_met?
    morning_nine = Time.zone.parse("9:00 AM")
  
    # 未完了のチェック項目が存在し、現在時刻が朝の9時より前の場合にtrueを返す
    current_time = Time.zone.now
    current_list.items.where(checked: false).exists? && current_time < morning_nine
  end

  def create_alert_email(item)
    recipient_id = item.list.user_id
    sender_id = current_user.id
  
    AlertEmail.new(
      title: "アイテムのアラート",
      body: "アイテムが更新されました。\n#{item.name}: #{item.description}",
      sender_id: sender_id,
      recipient_id: recipient_id
    )
  end
end
