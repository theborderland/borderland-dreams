class User < ApplicationRecord
  extend AppSettings
  include RegistrationValidation
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [ :facebook, :saml ]

  has_many :tickets
  has_many :roles, -> { distinct("name") }
  has_many :memberships
  has_many :camps, through: :memberships
  has_many :favorites
  has_many :favorite_camps, through: :favorites, source: :camp
  has_many :created_camps, class_name: :Camp

  schema_validations whitelist: [:id, :created_at, :updated_at, :encrypted_password]

  def is_member?
    roles.pluck(:name).include?("Borderland 2019 Membership")
  end

  def self.from_omniauth(auth)
    u = where(email: auth.uid).first_or_create! do |user|
      user.email = auth.uid # .info.email TODO for supporting other things than keycloak
      user.password = Devise.friendly_token[0,20]
      user.grants = nil
    end
    # Omniauth doesn't know the keycloak schema
    info = auth.extra.raw_info
    u.name = info.all.dig("urn:oid:2.5.4.42", 0).to_s
    # Last name : urn:oid:2.5.4.4

    info.all["Role"].map { |name| u.roles.build(name: name) }
    u.grants ||= 10 if u.roles.map(&:name).include?("Borderland 2019 Membership") # TODO multi event


    # avatars: get https://talk.theborderland.se/api/v1/profile/{username}
    # either loomio picture or gravatar
    u.save!
    u
  end
end
