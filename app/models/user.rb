class User < ApplicationRecord

	attr_accessor :activation_token 
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i

	validates :username, :presence => true, :length => {:minimum => 6}, :uniqueness => true
	validates :email, :presence => true, format: {with: VALID_EMAIL_REGEX}, :uniqueness => true

	before_save :downcase_email

	has_secure_password
	validates :password, :presence => true, :length => {:minimum => 5}, allow_nil: true

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def forget 
		update_attribute(:remember_digest, nil)
	end

	def authenticated?(attribute, token)
		digest = send('#(attribute)_digest')
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def activate
		update_columns(activated: true, activated_at: Time.zone.now)
	end

	def send_activation_email
    	UserMailer.account_activation(self).deliver_now
  	end

	def create_reset_digest 
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	private 

	def downcase_email
		self.email = email.downcase
	end

	def create_activation_digest
		self.activation_token = User.new_token 
		self.activation_digest = User.digest(activation_token)
	end

end
