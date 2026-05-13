# == Schema Information
#
# Table name: user_profiles
#
#  id             :integer          not null, primary key
#  address        :string
#  birth_date     :date
#  city           :string
#  country        :string
#  created_by     :integer
#  current_status :string
#  gender         :string
#  marital_status :string
#  nationality    :string
#  occupation     :string
#  phone          :string
#  state          :string
#  updated_by     :integer
#  zip            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id)
#
class UserProfile < ApplicationRecord
  has_one_attached :avatar
  belongs_to :user
end
