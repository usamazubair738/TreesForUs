class User < ApplicationRecord
  # ===================================================
  # DEVISE
 devise :database_authenticatable,
       :registerable,
       :recoverable,
       :rememberable,
       :validatable,
       :confirmable
  with_options if: :login_enabled? do
    validates :email, presence: true
    validates :password, presence: true
  end
  # ===================================================
  # CALLBACKS
  # ===================================================
  after_create :create_default_profile, unless: :user_profile_present?

  # ===================================================
  # ASSOCIATIONS
  # ===================================================

  # -------------------------
  # PROFILE
  # -------------------------
  has_one :user_profile, dependent: :destroy

  accepts_nested_attributes_for :user_profile,
                                update_only: true,
                                allow_destroy: true

  # -------------------------
  # FAMILY MEMBERSHIPS
  # -------------------------
  has_many :family_memberships,
           dependent: :destroy

  has_many :families,
           through: :family_memberships

  accepts_nested_attributes_for :family_memberships,
                                allow_destroy: true

  # -------------------------
  # PARENT / CHILD RELATIONSHIPS
  # -------------------------
  has_many :parent_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :child_id,
           dependent: :destroy

  has_many :child_relationships,
           class_name: "UserParentRelationship",
           foreign_key: :parent_id,
           dependent: :destroy

  has_many :parents,
           through: :parent_relationships,
           source: :parent

  has_many :children,
           through: :child_relationships,
           source: :child

  # -------------------------
  # PARTNER RELATIONSHIPS
  # -------------------------
  has_many :user_partners,
           class_name: "UserPartner",
           foreign_key: :user_id,
           dependent: :destroy

  has_many :inverse_user_partners,
           class_name: "UserPartner",
           foreign_key: :partner_id,
           dependent: :destroy

  has_many :partners,
           through: :user_partners,
           source: :partner

  has_many :inverse_partners,
           through: :inverse_user_partners,
           source: :user

  # ===================================================
  # ENUMS
  # ===================================================
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

  # ===================================================
  # SCOPES
  # ===================================================
  scope :with_login, -> { where(login_enabled: true) }
  scope :tree_only,  -> { where(login_enabled: false) }

  # ===================================================
  # VIRTUAL ATTRIBUTES
  # ===================================================
  attr_accessor :new_family_name

  # ===================================================
  # VALIDATIONS
  # ===================================================

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :identification_number,
            presence: true,
            uniqueness: {
              scope: :identification_type
            }

  validate :cannot_have_more_than_two_families
  # validate :identification_number_format

   def identification_number_format
    return if identification_type.blank? || identification_number.blank?

    case identification_type
    when "nric"
      # Example: Malaysian NRIC format (simplified)
      unless identification_number.match?(/\A\d{6}-\d{2}-\d{4}\z/)
        errors.add(:identification_number, "must be in NRIC format XXXXXX-XX-XXXX")
      end

    when "passport"
      # Common passport pattern (alphanumeric, 6–9 chars)
      unless identification_number.match?(/\A[A-Z0-9]{6,9}\z/i)
        errors.add(:identification_number, "must be a valid passport number")
      end

    when "driving_license"
      # Example: alphanumeric, 5–15 chars
      unless identification_number.match?(/\A[A-Z0-9\-]{5,15}\z/i)
        errors.add(:identification_number, "must be a valid driving license number")
      end

    when "birth_certificate"
      # Example: digits only (adjust if your country differs)
      unless identification_number.match?(/\A\d{6,20}\z/)
        errors.add(:identification_number, "must be a valid birth certificate number")
      end
    end
  end
  # ===================================================
  # DEVISE OVERRIDES
  # ===================================================

  # Email required only for login-enabled users
  def email_required?
    login_enabled?
  end

  # Password required only for login-enabled users
  def password_required?
    return false unless login_enabled?

    new_record? || password.present? || password_confirmation.present?
  end

  # ===================================================
  # BUSINESS RULES
  # ===================================================
  def cannot_have_more_than_two_families
    return if families.size <= 2

    errors.add(:families, "cannot exceed 2")
  end

  # ===================================================
  # RANSACK
  # ===================================================
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      first_name
      last_name
      email
      role
      status
      identification_type
      identification_number
      login_enabled
      created_at
      updated_at
    ]
  end

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

  # ===================================================
  # CLASS HELPERS
  # ===================================================
  def self.status_options
    statuses.keys.map { |status| [status.humanize, status] }
  end
  def self.identification_type_options
    identification_types.keys.map do |type|
    [type.humanize, type]
    end 
  end
  # ===================================================
  # INSTANCE HELPERS
  # ===================================================
  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def initials
    "#{first_name.to_s.first}#{last_name.to_s.first}".upcase
  end

  def age
    return "-" unless user_profile&.birth_date.present?

    ((Date.current - user_profile.birth_date) / 365.25).floor
  end

  def all_partners
    (partners + inverse_partners).uniq
  end

  def login_user?
    login_enabled?
  end

  def tree_member?
    !login_enabled?
  end

  # ===================================================
  # PRIVATE METHODS
  # ===================================================
  private

  def user_profile_present?
    user_profile.present?
  end

  def create_default_profile
    create_user_profile!(
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