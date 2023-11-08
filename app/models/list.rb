class List < ApplicationRecord
  belongs_to :user
  has_many :items,dependent: :destroy

  validates :name, presence: { message: "を入力してください" }
end
