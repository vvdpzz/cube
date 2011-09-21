class Answer < ActiveRecord::Base
  # Associations
  belongs_to :user, :counter_cache => true
  belongs_to :question, :counter_cache => true
  
  # Validations
  validates_presence_of :content, :message => t(:content_blank_warning)
  validate :enough_credit

  def enough_credit
    if self.question.not_free? and self.question.correct_answer_id == 0 and self.user.credit < Settings.answer_price
      errors.add :credit, t(:credit_not_enough_to_answer_warning)
    end
  end
end
