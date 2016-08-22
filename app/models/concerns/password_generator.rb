module PasswordGenerator
  extend ActiveSupport::Concern

  def generate_random_password(length = 8)
    chars = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
    (0...length).map{ chars[SecureRandom.random_number(chars.length)] }.join
  end
end
