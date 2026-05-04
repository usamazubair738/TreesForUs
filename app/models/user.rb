class User < ApplicationRecord
  has_many :parent_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :child_id

  has_many :child_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :parent_id

  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships

  has_many :user_partners
  has_many :partners, through: :user_partners, source: :partner

  has_many :inverse_user_partners, class_name: 'UserPartner', foreign_key: 'partner_id'
  has_many :inverse_partners, through: :inverse_user_partners, source: :user

  enum :status, alive: 0, dead: 1
  enum :identification_type, nric: 0, passport: 1, driving_license: 2

  def self.status_options
    statuses.keys.map { |s| [s.humanize, s] }
  end

  def self.identification_types
    identification_types.keys.map { |s| [s.humanize, s] }
  end

  def all_partners
    partners + inverse_partners
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
