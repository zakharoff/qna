class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :question, foreign_keys: true, null: false

      t.timestamps
    end
  end
end
