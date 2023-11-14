class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :lists
  has_many :sent_alert_emails, class_name: 'AlertEmail', foreign_key: 'sender_id'
  has_many :received_alert_emails, class_name: 'AlertEmail', foreign_key: 'recipient_id'

  validates :name, presence: { message: "を入力してください" }
  validates :email, presence: { message: "を入力してください" }, format: { with: /\A[\w+\-.]+@gmail\.com\z/, message: "@gmail.comで入力してください" } 
  
  def username
    name || email
  end

  def alert_emails
    AlertEmail.where(sender_id: id).or(AlertEmail.where(recipient_id: id))
  end
end
