# == Schema Information
# Schema version: 20110625230548
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  login               :string(255)
#  email               :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer
#  failed_login_count  :integer
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  openid_identifier   :string(255)
#

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.disable_perishable_token_maintenance = true
    c.validate_login_field = false 
    c.validate_email_field = false
    c.validate_password_field = false 
  end 

end
