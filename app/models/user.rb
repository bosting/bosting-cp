class User < UserBase
  include PasswordGenerator

  devise :database_authenticatable, :lockable, :recoverable, :rememberable, :trackable, :validatable

  has_many :apaches

  before_validation :set_random_password

  attr_accessor :with_random_password

  def self.get_collection
    select([:id, :name, :email]).map { |u| [u.to_label, u.id] }
  end

  private
  def set_random_password
    self.password = generate_random_password if with_random_password
  end
end
