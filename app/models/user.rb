class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :lists
  has_many :sent_alert_emails, class_name: 'AlertEmail', foreign_key: 'sender_id'
  has_many :received_alert_emails, class_name: 'AlertEmail', foreign_key: 'recipient_id'
       
end
