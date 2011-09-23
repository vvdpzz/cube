class Question < ActiveRecord::Base
  # Associations
  belongs_to :user, :counter_cache => true
  has_many :answers, :dependent => :destroy
  
  attr_accessible :id, :user_id, :title, :content, :credit, :money, :answers_count, :votes_count, :correct_answer_id, :created_at, :updated_at
  
  # Validations
  validates_presence_of :title, :message => "title_blank_warning"
  validate [:enough_credit, :enough_money]
  
  # Scopes
  scope :free, lambda { where(["credit = 0 AND money = 0.00"]) }
  scope :paid, lambda { where(["credit <> 0 OR money <> 0.00"])}
  
  default_scope order("created_at DESC")
  
  def enough_credit
    errors.add(:credit, "credit_not_enough_warning") if self.user.credit < self.credit
  end
  
  def enough_money
    errors.add(:money, "money_not_enough_warning") if self.user.money < self.money
  end
  
  def not_free?
    self.credit != 0 or self.money != 0
  end
  
  # Call MySQL Stored Procedure
  def self.strong_insert(id, user_id, title, content, credit, money)
    ActiveRecord::Base.connection.execute("call sp_deduct_credit_and_money(#{id},#{user_id},'#{title}','#{content}',#{credit},#{money})")
  end
  
end