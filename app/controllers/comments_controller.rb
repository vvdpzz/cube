class CommentsController < ApplicationController
  # before_filter :who_called_comment
  
  def new
  end
  
  # POST /questions/:id/comments
  def create
    instance = Question.find_by_id params[:id]
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
    
    respond_to do |format|
      if Question.strong_update_comment(@instance.id,new_comments)
        format.json { render :json => hash }
      end
    end
  end
  
  protected
  def who_called_comment
    params.each do |name, value|
      if name =~ /(.+)_id$/
        instance = $1.classify.constantize.find(value)
        instance_type = $1
      end
    end
  end
end
