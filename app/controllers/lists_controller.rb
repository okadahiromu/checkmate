class ListsController < ApplicationController
  before_action :authenticate_user! # ログイン認証が必要

  def index
    @lists = current_user.lists
  end

  def show
    @list = current_user.lists.find(params[:id])
  end

  def new
    @list = current_user.lists.build
  end

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      redirect_to @list, notice: 'リストを作成しました'
    else
      render :new
    end
  end

  def edit
    @list = current_user.lists.find(params[:id])
  end

  def update
    @list = current_user.lists.find(params[:id])
    if @list.update(list_params)
      redirect_to @list, notice: 'リストを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @list = current_user.lists.find(params[:id])
    @list.destroy
    redirect_to lists_path, notice: 'リストを削除しました'
  end

  private

  def list_params
    params.require(:list).permit(:name, :description)
  end
end
