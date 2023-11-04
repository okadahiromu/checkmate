class Item < ApplicationRecord
  belongs_to :list

  def toggle_check
    update(checked: !checked)
  end

end
