# == Schema Information
#
# Table name: family_memberships
#
#  id              :integer          not null, primary key
#  membership_type :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  family_id       :integer          not null
#  user_id         :integer          not null
#
# Indexes
#
#  index_family_memberships_on_family_id  (family_id)
#  index_family_memberships_on_user_id    (user_id)
#
# Foreign Keys
#
#  family_id  (family_id => families.id)
#  user_id    (user_id => users.id)
#
class FamilyMembership < ApplicationRecord
  belongs_to :user
  belongs_to :family
 enum :membership_type, {
  birth: 0,
  marriage: 1
}
  validates :user_id, uniqueness: {
    scope: :family_id
  }

  validates :membership_type, uniqueness: {
    scope: :user_id,
    message: "family already assigned"
  }
end