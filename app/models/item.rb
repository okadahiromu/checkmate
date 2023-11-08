class Item < ApplicationRecord
  belongs_to :list

  validates :name, presence: { message: "名前を入力してください" }

  def toggle_check
    update(checked: !checked)
  end
end
