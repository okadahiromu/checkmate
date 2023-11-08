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
      AlertMailer.send_alert(@item).deliver
      redirect_to list_items_path, notice: 'アイテムを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  

  def update
    @item = current_list.items.find(params[:id])
  
    # アイテムの状態を反転させて更新
    if @item.update(checked: !@item.checked)
      redirect_to list_items_path(current_list), notice: 'アイテムのチェックが更新されました'
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

  def send_alert_mail_if_needed(item)
    if @item.checked_changed? && @item.checked
      AlertMailer.alert_email(@item).deliver_now
    end
  end
end
