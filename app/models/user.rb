# == Schema Information
# Schema version: 20110625210611
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  login               :string(255)
#  email               :string(255)
#  cypted_password     :string(255)
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
#

class User < ActiveRecord::Base
  acts_as_authentic do |c|
  end 

end
