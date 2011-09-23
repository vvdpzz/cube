class QuestionsController < ApplicationController
  # GET /questions/paid
  def paid
    
  end
  
  # GET /questions/free
  def free
    
  end
  
  # GET /questions/nearby
  def nearby
    
  end
  
  # GET /questions/watching
  def watching
    
  end
  
  # GET /questions/:id
  def show
    
  end
  
  # POST /questions
  def create
    id, user_id, title, content, credit, money = UUIDList.pop, current_user_id, params[:title], params[:content], params[:credit].to_i, params[:money].to_i
    question = Question.new :id => uuid, :user_id => user_id, :title => title, :content => content, :credit => credit, :money => money
    respond_to do |format|
      if question.valid?
        Question.strong_insert(id, user_id, title, content, credit, money)
        format.json { render :json => question, :status => :created, :location => question }
      else
        format.json { render :json => question.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /questions/:id
  def update
    id, title, content, credit, money = params[:id], params[:title], params[:content], params[:credit].to_i, params[:money].to_i
    respond_to do |format|
      if question.valid?
        Question.strong_update id title content credit money
        format.json { render :json => question, :status => :created, :location => question }
      else
        format.json { render :json => question.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /questions/:id/star
  def star
    if not current_user.star_questions.exists?(:question_id => params[:id])
      current_user.star_questions.create(:question_id => params[:id])
    end
    respond_to do |format|
      format.json { head :ok }
    end
  end
  
  # DELETE /questions/:id/star
  def unstar
    star = current_user.star_questions.find_by_question_id params[:id]
    star.destroy
    respond_to do |format|
      format.json { head :ok }
    end
  end
  
  # GET /questions/:id/star
  def is_star
    respond_to do |format|
      if current_user.star_questions.exists?(:question_id => params[:id])
        format.json { head :no_content }
      else
        format.json { head :not_found }
      end
    end
  end
  
  # PUT /questions/:id/follow
  def follow
    if not current_user.follow_questions.exists?(:question_id => params[:id])
      current_user.follow_questions.create(:question_id => params[:id])
    end
    respond_to do |format|
      format.json { head :ok }
    end
  end
  
  # DELETE /questions/:id/follow
  def unfollow
    follow = current_user.follow_questions.find_by_question_id params[:id]
    follow.destroy
    respond_to do |format|
      format.json { head :ok }
    end
  end
  
  # GET /questions/:id/follow
  def is_follow
    respond_to do |format|
      if current_user.follow_questions.exists?(:question_id => params[:id])
        format.json { head :no_content }
      else
        format.json { head :not_found }
      end
    end
  end
end