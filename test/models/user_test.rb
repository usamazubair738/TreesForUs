# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  created_by             :integer
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string
#  failed_attempts        :integer          default(0), not null
#  first_name             :string           not null
#  identification_number  :string           not null
#  identification_type    :integer          default("nric"), not null
#  last_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  login_enabled          :boolean          default(FALSE), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  sign_in_count          :integer          default(0), not null
#  status                 :integer          default("alive"), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  parent_id              :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_id_type_and_number    (identification_type,identification_number) UNIQUE
#  index_users_on_parent_id             (parent_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
