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
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string           not null
#  identification_number  :string           not null
#  identification_type    :integer          default("nric"), not null
#  last_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default(0), not null
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
class User < ApplicationRecord
  has_many :parent_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :child_id

  has_many :child_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :parent_id

  has_one :user_profile, dependent: :destroy
  after_create :build_default_profile

  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships

  has_many :user_partners
  has_many :partners, through: :user_partners, source: :partner

  has_many :inverse_user_partners, class_name: 'UserPartner', foreign_key: 'partner_id'
  has_many :inverse_partners, through: :inverse_user_partners, source: :user

  enum :status, alive: 0, dead: 1
  enum :identification_type, nric: 0, passport: 1, driving_license: 2, birth_certificate: 3


  def self.status_options
    statuses.keys.map { |s| [s.humanize, s] }
  end

   def self.identification_type_options
    identification_types.keys.map do |type|
      [type.humanize, type]
    end
  end

  def all_partners
    partners + inverse_partners
  end
  
  def build_default_profile
    create_user_profile(
      birth_date: nil,
      gender: nil,
      marital_status: nil,
      occupation: nil,
      address: nil,
      city: nil,
      state: nil,
      zip: nil,
      country: nil,
      phone: nil,
      nationality: nil
    )
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
