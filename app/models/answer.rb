# coding: UTF-8
class Answer < ActiveRecord::Base
  # Associations
  belongs_to :user, :counter_cache => true
  belongs_to :question, :counter_cache => true
  
  # Validations
  validates_presence_of :content, :message => t(:content_blank_warning)
  validate :enough_credit

  def self.basic_hash(answer_id)
    answers = Answer.select("id,user_id,content,is_correct,votes_count,created_at").find_by_id(answer_id)
    data = answers.collect{ |answers| answer.serializable_hash }
  end

  def enough_credit
    if self.question.not_free? and self.question.correct_answer_id == 0 and self.user.credit < Settings.answer_price
      errors.add :credit, t(:credit_not_enough_to_answer_warning)
    end
  end
  
  def self.strong_insert(id, user_id, question_id, content, answer_price)
    sql = ActiveRecord::Base.connection()
    sql.execute "SET autocommit=0"
    sql.begin_db_transaction
    sql.update "INSERT INTO answer (id, user_id, question_id, content) VALUES (#{id},#{user_id},#{question_id},#{content})";
    sql.update "UPDATE users SET updated_at = NOW(), credit = credit - #{answer_price} WHERE users.id = #{user_id}"
    sql.commit_db_transaction
  end  
  
  # Call MySQL Stored Procedure
  def self.strong_accept_answer(question_id, answer_id, user_id, credit, money)
    ActiveRecord::Base.connection.execute("call sp_answer_accept(#{question_id}, #{answer_id}, #{user_id}, #{credit}, #{money})")
  end

  def enough_credit_to_pay
    if self.question.not_free? and self.question.correct_answer_id == 0 and self.user.credit < Settings.answer_price
      errors.add(:credit, "you do not have enough credit to pay.")
    end
  end
  
  def deduct_credit
    self.user.update_attribute(:credit, self.user.credit - Settings.answer_price)
  end
  
  def order_credit
    CreditTransaction.create(
      :user_id => self.user.id,
      :question_id => self.question.id,
      :answer_id => self.id,
      :value => Settings.answer_price,
      :trade_type => TradeType::ANSWER,
      :trade_status => TradeStatus::NORMAL
    )
  end
end
