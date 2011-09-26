class AnswersController < ApplicationController
  # POST /answers
  def create
    id, user_id, question_id, content, is_correct, vote_count = UUIDList.pop, current_user.id, params[:question_id], params[:answer]
    answer = Answer.new :id => id, :user_id => user_id, :question_id => question_id, :content => content
    description = APP_CONFIG["notice_comment_#{@instance_type}"]
    
    respond_to do |format|
      if answer.save
        question = Question.find_by_id id
        data = question.serializable_hash
        data.merge! User.basic_hash current_user.id
        format.json { render :json => data, :status => :created, :location => question }
      else
        format.json { render :json => question.errors, :status => :unprocessable_entity }
      end
    end
  end

    
      if @answer.save
        question.not_free? and question.correct_answer_id == 0 and @answer.deduct_credit and @answer.order_credit
        # format.html { redirect_to question, :notice => 'Answer was successfully created.' }
        question.async_new_answer(@answer.id)
        format.js
        format.json { render :json => @answer, :status => :created, :location => [question, @answer] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /questions/:question_id/answers/:id/accept
  def accept
    
  end
end
