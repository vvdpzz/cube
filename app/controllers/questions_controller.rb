class QuestionsController < ApplicationController
  before_filter :vote_init, :only => [:vote_for, :vote_against]
  
  # GET /questions/paid
  def paid
    questions = Question.paid.select("id, title, credit, money, answers_count, votes_count, created_at")
    data = questions.collect{ |question| question.serializable_hash }
    respond_to do |format|
      format.json { render :json => data, :status => :ok }
    end
  end
  
  # GET /questions/free
  def free
    questions = Question.free.select("id, title, credit, money, answers_count, votes_count, created_at")
    data = questions.collect{ |question| question.serializable_hash }
    respond_to do |format|
      format.json { render :json => data, :status => :ok }
    end
  end
  
  # GET /questions/nearby?lat=&lnt=
  def nearby
    lat = params[:lat]
    lnt = params[:lnt]
  end
  
  # GET /questions/watching
  def watching
    
  end
  
  # GET /questions/:id
  def show
    question = Question.find_by_id params[:id]
    q_hash = question.serializable_hash
    if question.comments
      question.comments = "[" + question.comments + "]"
      c_hash = MultiJson.decode question.comments
      q_hash["comments"] = c_hash
    end
    q_data = q_hash.merge! User.basic_hash question.user_id
    answers = Answer.where(:question_id => params[:id])
    a_hash = answers.collect{ |answer| answer.serializable_hash.merge!(User.basic_hash answer.user_id)}
    q_data = q_data.merge!({:answers => a_hash})
    respond_to do |format|
      format.json { render :json => q_data }
    end
  end
  
  # POST /questions/:id/comments
  def create_comment
    question_id = params[:id]
    instance = Question.find_by_id question_id
    old_comments = instance.comments
    
    hash = {}
    hash.merge! User.basic_hash current_user.id
    hash[:content] = params[:content]
    hash[:created_at] = Time.now
    
    if old_comments.nil? 
      old_comments = '' 
      new_comments = MultiJson.encode(hash)
    else
      new_comments = old_comments + ',' + MultiJson.encode(hash)
    end
    
    Notification.notif_new_q_comment(receiver_id,question_id)
    respond_to do |format|
      Question.strong_update_comment(instance.id,new_comments)
      format.json { render :json => hash, :status => :created }
    end
  end
  
  # POST /questions
  def create
    id, user_id, title, content, credit, money = UUIDList.pop, current_user.id, params[:title], params[:content], params[:credit].to_i, params[:money].to_i
    question = Question.new :id => id, :user_id => user_id, :title => title, :content => content, :credit => credit, :money => money
    respond_to do |format|
      if question.valid?
        Question.strong_create_question(id, user_id, title, content, credit, money)
        question = Question.find_by_id id
        data = question.serializable_hash
        data.merge! User.basic_hash current_user.id
        format.json { render :json => data, :status => :created, :location => question }
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
  
  # TODO vvdpzz will do vote day limit
  # PUT /questions/:id/vote_for
  def vote_for
    if current_user.credit >= Settings.vote_for_limit and @voted != true
      if @voted == nil
        current_user.vote_for @question
      else
        current_user.vote_exclusively_against @question
      end
    end
  end
  
  # PUT /questions/:id/vote_against
  def vote_against
    if current_user.credit >= Settings.vote_against_limit and @voted != false
      if @voted == nil
        current_user.vote_against @question
      else
        current_user.vote_exclusively_for @question
      end
    end
  end
  
  protected
    def vote_init
      @question = Question.select("id").find_by_id(params[:id])
      @voted = @question.trivalent_voted_by? current_user
    end
end