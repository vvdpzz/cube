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
    
  end
  
  # PUT /questions/:id
  def update
    
  end
  
  # PUT /questions/:id/star
  def star
    current_user.star_questions.create(:question_id => params[:id])
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
        format.json { :status => :no_content }
      else
        format.json { :status => :not_found }
      end
    end
  end
  
  # PUT /questions/:id/follow
  def follow
    current_user.follow_questions.create(:question_id => params[:id])
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
        format.json { :status => :no_content }
      else
        format.json { :status => :not_found }
      end
    end
  end
end