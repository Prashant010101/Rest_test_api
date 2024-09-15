class CreateOtpVerifications < ActiveRecord::Migration[7.1]
  def change
    create_table :otp_verifications do |t|
      t.integer :otp_code
      t.string :email
      
      t.timestamps
    end
  end
end
