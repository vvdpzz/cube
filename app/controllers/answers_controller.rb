class AnswersController < ApplicationController
  # POST /answers
  def create
    question = Question.find params[:question_id]
    if question.was_not_answered_by? current_user.id
      @answer = current_user.answers.build(params[:answer])

      respond_to do |format|
        if @answer.save
          question.not_free? and question.correct_answer_id == 0 and @answer.deduct_credit and @answer.order_credit
          question.async_new_answer(@answer.id)
          format.html { redirect_to question, :notice => 'Answer was successfully created.' }
          format.json { render :json => @answer, :status => :created, :location => [question, @answer] }
        else
          format.html { render :action => "new" }
          format.json { render :json => @answer.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  # PUT /questions/:question_id/answers/:id/accept
  def accept
    question = Question.find params[:question_id]
    answer = question.answers.find params[:id]
    if question and answer and current_user.id == question.user_id and question.correct_answer_id == 0
      question.update_attribute(:correct_answer_id, answer.id)
      answer.update_attribute(:is_correct, true)
      if question.not_free?
        if question.credit > 0
          answer.user.update_attribute(:credit, answer.user.credit + question.credit)
          order = CreditTransaction.new(
            :user_id => answer.user.id,
            :question_id => question.id,
            :answer_id => answer.id,
            :value => question.credit,
            :payment => false,
            :trade_type => TradeType::ACCEPT,
            :trade_status => TradeStatus::SUCCESS
          )
          order.save
          
          # change question user's order status from normal to success
          orders = current_user.credit_transactions.where(:question_id => question.id, :trade_type => TradeType::ASK)
          orders.each do |order|
            order.update_attributes(
              :trade_status => TradeStatus::SUCCESS,
              :answer_id => answer.id,
              :winner_id => answer.user.id
            )
          end
        end
        if question.money > 0
          answer.user.update_attribute(:money , answer.user.money  + question.money )
          order = MoneyTransaction.new(
            :user_id => answer.user.id,
            :question_id => question.id,
            :answer_id => answer.id,
            :value => question.money,
            :payment => false,
            :trade_type => TradeType::ACCEPT,
            :trade_status => TradeStatus::SUCCESS
          )
          order.save
          
          # change question user's order status from normal to success
          orders = current_user.money_transactions.where(:question_id => question.id, :trade_type => TradeType::ASK)
          orders.each do |order|
            order.update_attributes(
              :trade_status => TradeStatus::SUCCESS,
              :answer_id => answer.id,
              :winner_id => answer.user.id
              )
          end
        end
      end
      question.async_accept_answer(answer.id)
    end
    redirect_to question
  end
  end
end
