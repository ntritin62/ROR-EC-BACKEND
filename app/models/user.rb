class User < ApplicationRecord
  SIGN_UP_REQUIRE_ATTRIBUTES = %i(email password
password_confirmation avatar).freeze
 
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one :cart, dependent: :destroy

  enum role: {customer: 0, admin: 1}

  has_secure_password

  validates :full_name,
            length: {maximum: Settings.value.max_name}

  validates :phone_number,
            format: {with: Settings.value.phone_format},
            allow_blank: true

  validates :email,
            presence: true,
            length: {maximum: Settings.value.max_name},
            format: {with: Settings.value.valid_email},
            uniqueness: {case_sensitive: false}

  validates :password,
            presence: true,
            length: {minimum: Settings.value.min_user_password},
            allow_nil: true

  after_create :create_cart_for_user

  private
  def create_cart_for_user
    # Tạo cart cho user sau khi user được tạo
    self.create_cart
  end        
end
