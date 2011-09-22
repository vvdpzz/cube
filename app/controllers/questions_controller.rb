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
    uuid, user_id, title, content, credit, money = UUIDList.pop, current_user_id, params[:title], params[:content], params[:credit].to_i, params[:money].to_i
    question = Question.new :id => uuid, :user_id => user_id, :title => title, :content => content, :credit => credit, :money => money
    respond_to do |format|
      if question.valid?
        #Question.strong_insert user_id, title, content, credit, money
        Question.strong_insert(uuid, user_id, title, content, credit, money)
        format.json { render :json => question, :status => :created, :location => question }
      else
        format.json { render :json => question.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /questions/:id
  def update
    
  end
  
  # PUT /questions/:id/star
  def star
    
  end
  
  # DELETE /questions/:id/star
  def unstar
    
  end
  
  # GET /questions/:id/star
  def is_star
    
  end
  
  # PUT /questions/:id/follow
  def follow
    
  end
  
  # DELETE /questions/:id/follow
  def unfollow
    
  end
  
  # GET /questions/:id/follow
  def is_follow
    
  end
end