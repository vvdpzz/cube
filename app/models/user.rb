class User < ActiveRecord::Base
  devise :token_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :email, :password, :remember_me
  attr_accessible :login, :realname, :username, :credit, :money, :about_me
  attr_accessible :authentication_token
  attr_accessor :login
  
  # Callbacks
  before_create :create_login
  before_create :ensure_authentication_token
  
  # Associations
  has_many :questions
  has_many :answers
  
  has_many :star_questions
  has_many :follow_questions
  
  acts_as_voter
  
  def self.basic_hash(user_id)
    {:user => User.select("id, username, realname").find_by_id(user_id).serializable_hash}
  end
  
  protected
    def create_login
      if self.username.empty?
        email = self.email.split(/@/)
        login_taken = User.where(:username => email[0]).first
        self.username = email[0] unless login_taken
      end
    end

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    end
end