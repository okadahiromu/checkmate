class CreateAlertEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :alert_emails do |t|
      t.string :title
      t.text :body
      t.integer :sender_id
      t.integer :recipient_id
      t.string :status
      t.datetime :sent_at

      t.timestamps
    end
  end
end
