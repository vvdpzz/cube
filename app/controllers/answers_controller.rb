class AnswersController < ApplicationController
  # POST /answers
  def create
    if question.was_not_answered_by? current_user.id
      id, user_id, question_id, content = UUIDList.pop, current_user.id, params[:question_id], params[:content]
      answer = Answer.new :id => id, :user_id => user_id, :question_id => question_id, :content => content
      answer_price = Settings.answer_price
      question_info = Question.select('credit,money').where(:id => params[:question_id])
      respond_to do |format|
        if answer.valid?
          if question_info.credit > 0 or question_info.money > 0
            Answer.strong_create_pay_answer(id, user_id, question_id, content, answer_price)
          else
            Answer.strong_create_free_answer(id, user_id, question_id, content)
          end
          answer = Answer.find_by_id id
          data = answer.serializable_hash
          data.merge! User.basic_hash current_user.id
          format.json { render :json => data, :status => :created, :location => answer }
        else
          format.json { render :json => answer.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
 
  # PUT /questions/:question_id/answers/:id/accept
  def accept
    # 1 User: add credit and/or money to user table
    # 2 CreditTransaction and/or MoneyTransaction
    # 3 Question: mark correct answer
    # 4 Answer: mark is correct answer
    
    #:payment => false,
    #:trade_type => TradeType::ACCEPT,
    #:trade_status => TradeStatus::SUCCESS

    question_id,answer_id,user_id = params[:question_id], params[:id], current_user.id
    question_info = Question.select('user_id,credit,money,correct_answer_id').where(:id => question_id)
    credit,money = question_info.credit,question_info.money
    if question_info.user_id != current_user.id and question_info.correct_answer_id == 0
      Question.strong_accept_answer(question_id, answer_id, user_id, credit, money)
      question.async_accept_answer(answer.id)
      respond_to do |format|
        format.json { head :ok }
      end
    end
  end
    
#    question = Question.find params[:question_id]
#    answer = question.answers.find params[:id]
#    if question and answer and current_user.id == question.user_id and question.correct_answer_id == 0
#      question.update_attribute(:correct_answer_id, answer.id)
#      answer.update_attribute(:is_correct, true)
#      if question.not_free?
#        if question.credit > 0
#          answer.user.update_attribute(:credit, answer.user.credit + question.credit)
#          order = CreditTransaction.new(
#            :user_id => answer.user.id,
#            :question_id => question.id,
#            :answer_id => answer.id,
#            :value => question.credit,
#            :payment => false,
#            :trade_type => TradeType::ACCEPT,
#            :trade_status => TradeStatus::SUCCESS
#          )
#          order.save
#          
#          # change question user's order status from normal to success
#          orders = current_user.credit_transactions.where(:question_id => question.id, :trade_type => TradeType::ASK)
#          orders.each do |order|
#            order.update_attributes(
#              :trade_status => TradeStatus::SUCCESS,
#              :answer_id => answer.id,
#              :winner_id => answer.user.id
#            )
#          end
#        end
#        if question.money > 0
#          answer.user.update_attribute(:money , answer.user.money  + question.money )
#          order = MoneyTransaction.new(
#            :user_id => answer.user.id,
#            :question_id => question.id,
#            :answer_id => answer.id,
#            :value => question.money,
#            :payment => false,
#            :trade_type => TradeType::ACCEPT,
#            :trade_status => TradeStatus::SUCCESS
#          )
#          order.save
#          
#          # change question user's order status from normal to success
#          orders = current_user.money_transactions.where(:question_id => question.id, :trade_type => TradeType::ASK)
#          orders.each do |order|
#            order.update_attributes(
#              :trade_status => TradeStatus::SUCCESS,
#              :answer_id => answer.id,
#              :winner_id => answer.user.id
#              )
#          end
#        end
#      end
#      question.async_accept_answer(answer.id)
#    end
#    redirect_to question
#  end
end
