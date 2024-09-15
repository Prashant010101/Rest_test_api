class AddUserToOtpVerifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :otp_verifications, :user, null: false, foreign_key: true
  end
end
