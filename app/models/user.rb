class User < ApplicationRecord
  # ---------------------------------------------------
  # DEVISE
  # ---------------------------------------------------
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  # ---------------------------------------------------
  # CALLBACKS
  # ---------------------------------------------------
  after_create :build_default_profile

  # ---------------------------------------------------
  # ASSOCIATIONS
  # ---------------------------------------------------
  has_many :parent_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :child_id

  has_many :child_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :parent_id

  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships

  has_one :user_profile, dependent: :destroy
  accepts_nested_attributes_for :user_profile

  has_many :user_partners,
           class_name: "UserPartner",
           foreign_key: :user_id,
           dependent: :destroy

  has_many :inverse_user_partners,
           class_name: "UserPartner",
           foreign_key: :partner_id,
           dependent: :destroy

  has_many :partners, through: :user_partners, source: :partner
  has_many :inverse_partners, through: :inverse_user_partners, source: :user

  has_many :family_memberships
  has_many :families, through: :family_memberships

  # ---------------------------------------------------
  # ENUMS
  # ---------------------------------------------------
  enum :role, {
    family_manager: 0,
    viewer: 1,
    admin: 2
  }

  enum :status, {
    alive: 0,
    dead: 1
  }

  enum :identification_type, {
    nric: 0,
    passport: 1,
    driving_license: 2,
    birth_certificate: 3
  }

  # ---------------------------------------------------
  # SCOPES
  # ---------------------------------------------------
  scope :with_login, -> { where(login_enabled: true) }
  scope :tree_only, -> { where(login_enabled: false) }

  # ---------------------------------------------------
  # VIRTUAL ATTRIBUTES
  # ---------------------------------------------------
  attr_accessor :new_family_name

  # ---------------------------------------------------
  # VALIDATIONS
  # ---------------------------------------------------
  validate :cannot_have_more_than_two_families

  # ---------------------------------------------------
  # DEVISE OVERRIDES
  # ---------------------------------------------------
  def email_required?
    login_enabled?
  end

  def password_required?
    login_enabled?
  end

  # ---------------------------------------------------
  # BUSINESS RULES
  # ---------------------------------------------------
  def cannot_have_more_than_two_families
    return if families.size <= 2

    errors.add(:families, "cannot exceed 2")
  end

  # ---------------------------------------------------
  # CLASS HELPERS
  # ---------------------------------------------------
  def self.status_options
    statuses.keys.map { |s| [s.humanize, s] }
  end

  # ---------------------------------------------------
  # RANSACK ATTRIBUTES (what can be searched)
  # ---------------------------------------------------
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      email
      first_name
      last_name
      role
      status
      identification_type
      identification_number
      created_at
      updated_at
    ]
  end

  # ---------------------------------------------------
  # RANSACK ASSOCIATIONS (what can be joined in filters)
  # ---------------------------------------------------
  def self.ransackable_associations(auth_object = nil)
    %w[
      user_profile
      families
      family_memberships
      parents
      children
      partners
      inverse_partners
    ]
  end

  # ---------------------------------------------------
  # INSTANCE HELPERS
  # ---------------------------------------------------
  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}".upcase
  end

  def age
    return "-" unless respond_to?(:birth_date) && birth_date.present?
    ((Date.today - birth_date) / 365.25).floor
  end

  def all_partners
    partners + inverse_partners
  end

  # ---------------------------------------------------
  # DEFAULT PROFILE CREATION
  # ---------------------------------------------------
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
end