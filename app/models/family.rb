# == Schema Information
#
# Table name: families
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Family < ApplicationRecord
  has_many :family_memberships, dependent: :destroy
  has_many :users, through: :family_memberships
end
