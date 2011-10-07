class Question < ActiveRecord::Base
  include Twitter::Extractor
  
  set_primary_key :id
  
  belongs_to :user, :counter_cache => true, :select => [:id, :username, :realname]
  has_many :answers, :dependent => :destroy, :select => [:id, :question_id, :content, :is_correct, :votes_count]
  
  # validations
  validates_numericality_of :money, :message => "is not a number", :greater_than_or_equal_to => 0
  validates_numericality_of :credit, :message => "is not a number", :greater_than_or_equal_to => 0
  validates_presence_of :title, :message => "can't be blank"
  validate :enough_credit
  validate :enough_money
  
  # scopes
  scope :free, lambda { where(["credit = 0 AND money = 0.00"]) }
  scope :paid, lambda { where(["credit <> 0 OR money <> 0.00"])}
  default_scope order("created_at DESC")

  attr_accessible :id, :user_id, :title, :content, :credit, :money, :answers_count, :votes_count, :correct_answer_id, :created_at, :updated_at
  
  JSON_ATTRS = ['id', 'title', 'content', 'credit', 'money', 'answers_count', 'votes_count', 'created_at']
  
  def as_json_for_iOS
    attributes.slice(*JSON_ATTRS).merge(:user => user, :answers => answers)
  end
  
  def enough_credit
    errors.add(:credit, "credit_not_enough_warning") if self.user.credit < self.credit
  end
  
  def enough_money
    errors.add(:money, "money_not_enough_warning") if self.user.money < self.money
  end
  
  def not_free?
    self.credit != 0 or self.money != 0
  end
  
  def self.strong_create_question(id, user_id, title, content, credit, money)
    ActiveRecord::Base.connection.execute("call sp_deduct_credit_and_money(#{id},#{user_id},'#{title}','#{content}',#{credit},#{money})")
  end
  
  def self.strong_update_comment(question_id,new_comments)
    sql = ActiveRecord::Base.connection()
    sql.execute "SET autocommit=0"
    sql.begin_db_transaction
    sql.update "UPDATE questions SET comments = '#{new_comments}' WHERE id = #{question_id}";
    sql.commit_db_transaction
  end    
  
  def self.strong_update(id, title, content, credit, money)
    sql = ActiveRecord::Base.connection()
    sql.execute "SET autocommit=0"
    sql.begin_db_transaction
    sql.update "UPDATE questions SET title = '#{title}', content = '#{content}', credit = #{credit}, money = #{money} WHERE id = #{id}";
    sql.commit_db_transaction
  end
  
  def self.question_show_redis(id)
    # TODO: To store json in Redis
    question = Question.select('').where(:user_id => id)
    $redis.hset(h_q_show,"q#{id}","")
  end
   
  ["credit", "money"].each do |name|
    define_method "#{name}_rewarded?" do
      self.send(name) > 0
    end
    
    define_method "deduct_#{name}" do
      self.user.update_attribute(name.to_sym, self.user.send(name) - self.send(name))
    end
    
    define_method "order_#{name}" do
      if self.send(name) > 0
        "#{name}_transaction".classify.constantize.create(
          :user_id      => self.user.id,
          :question_id  => self.id,
          :value        => self.send(name),
          :trade_type   => TradeType::ASK,
          :trade_status => TradeStatus::NORMAL
        )
      end
    end
  end
  
  def followed_user_ids
    FollowedQuestion.select('user_id').where(:question_id => self.id, :status => true).collect{ |item| item.user_id }
  end
  
  def followed_by?(user_id)
    records = FollowedQuestion.where(:user_id => user_id, :question_id => self.id)
    records.empty? ? false : records.first.status
  end
  
  def favorited_by?(user_id)
    records = FavoriteQuestion.where(:user_id => user_id, :question_id => self.id)
    records.empty? ? false : records.first.status
  end
  
  def was_not_answered_by?(user_id)
    self.answers.select('user_id').where(:user_id => user_id).empty?
  end
  
  # asyncs
  def async_new_answer(answer_id)
    Resque.enqueue(NewAnswer, self.id, answer_id)
  end
  
  def async_accept_answer(answer_id)
    Resque.enqueue(AcceptAnswer, self.id, answer_id)
  end
  
end
