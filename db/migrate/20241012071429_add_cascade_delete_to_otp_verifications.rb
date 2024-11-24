class AddCascadeDeleteToOtpVerifications < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :otp_verifications, :users
    add_foreign_key :otp_verifications, :users, on_delete: :cascade
  end
end
