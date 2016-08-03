class User < ApplicationRecord

	include Gravtastic
	gravtastic

	WillPaginate.per_page = 30

	has_many :microposts, dependent: :destroy
	has_many :comments, dependent: :destroy

	has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent:   :destroy
	has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent:   :destroy

	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	attr_accessor :activation_token, :remember_token, :reset_token
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i

	validates :username, :presence => true, :length => {:minimum => 6}, :uniqueness => true
	validates :email, :presence => true, format: {with: VALID_EMAIL_REGEX}, :uniqueness => true
	validates :slug, uniqueness: true, presence: true, exclusion: {in: %w[sigh_up login]}

	before_save :downcase_email
	before_save :create_activation_digest
	before_validation :generate_slug

	has_secure_password
	validates :password, :presence => true, :length => {:minimum => 5}, allow_nil: true

	#extend FriendlyId
	#friendly_id :user, use: :slugged

	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	def following?(other_user)
		following.include?(other_user)
	end

	def feed
		following_ids_subselect = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"
    	Micropost.where("user_id IN (#{following_ids_subselect})
                     OR user_id = :user_id", user_id: id)
	end

	def to_param
		slug
	end

	def generate_slug
		self.slug ||= username.parameterize
	end

	def self.search(search)
		where(["username LIKE ?", "%#{search}%"])
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember 
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def forget 
		update_attribute(:remember_digest, nil)
	end

	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def activate
		update_attribute(:activated, true)
   		update_attribute(:activated_at, Time.zone.now)
	end

	def send_activation_email
    	UserMailer.account_activation(self).deliver_now
  	end

	def create_reset_digest 
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	def password_reset_expired?
		reset_sent_at < 2.hours.ago
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
