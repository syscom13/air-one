class AddPhoneAndPinVerifiedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pin, :string
    add_column :users, :phone_verified, :boolean
  end
end
