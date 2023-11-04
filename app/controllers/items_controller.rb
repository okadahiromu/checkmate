class ItemsController < ApplicationController
  before_action :authenticate_user! # ログイン認証が必要

  def index
    @items = current_list.items
  end

  def new
    @item = current_list.items.build
  end

  def create
    @item = current_list.items.build(item_params)
    if @item.save
      redirect_to list_items_path, notice: 'アイテムを作成しました'
    else
      render :new
    end
  end

  def edit
    @item = current_list.items.find(params[:id])
  end

  def update
    @item = current_list.items.find(params[:id])
    if @item.update(item_params)
      redirect_to list_items_path, notice: 'アイテムを更新しました'
    else
      render :edit
    end
  end

  private

  def current_list
    @current_list ||= current_user.lists.find(params[:list_id])
  end

  def item_params
    params.require(:item).permit(:name, :description)
  end
end
