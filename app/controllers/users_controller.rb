class UsersController < ApplicationController
  #GET /users/:id
  def show
    user = User.find params[:id]
    data = user.serializable_hash
    respond_to do |format|
      format.json { render :json => data, :status => :ok }
    end
    
  end

  #POST /users/:id/follow
  def follow
    user = User.find params[:id]
    if user and user.id != current_user.id
      # if not in Redis add relationship
      if not user.has_relationship_redis(current_user.id)
        user.followers.create(:follower_id => current_user.id)
        $redis.sadd("user:#{current_user.id}.follows", params[:id])
      # maybe not in Redis but in DB, add relationship also add in Redis
      elsif not user.has_relationship_db(user.id,current_user.id)
        user.followers.create(:follower_id => current_user.id)
        $redis.sadd("user:#{current_user.id}.follows", params[:id])
      end
      current_user.async_follow_user(user.id) if user.has_relationship_redis(current_user.id)
      Notification.notif_new_follower (user.id,current_user.id,current_user.realname)
      render :json => {:followed => true}
    else
      render :json => {:error => true}, :status => :unprocessable_entity
    end

    #user = User.find params[:id]
    #followed = true 
    #if user and user.id != current_user.id
    #  records = FollowedUser.where(:user_id => user.id, :follower_id => current_user.id)
    #  if records.empty?
    #    user.followers.create(:follower_id => current_user.id)
    #  else
    #    record = records.first
    #    followed = record.followed if record.update_attribute(:followed, !record.followed)
    #  end
    #  current_user.async_follow_user(user.id) if followed
    #  render :json => {:followed => followed}
    #else
    #  render :json => {:error => true}, :status => :unprocessable_entity
    #end
  end
  
  def unfollow
    following_user = User.find params[:id]
    if following_user
      if following_user.has_relationship_redis(current_user.id)
        following_user.followers.update_arributes(:following => false)
        $redis.serm("user:#{current_user.id}.follows", params[:id])
      elsif following_user.has_relationship_db(current_user.id)
        following_user.update_by_sql(params[:id],current_user.id)
      end
    end
    # TODO what kind of JSON data should I return?
  end
  
  def asked
    user = User.find params[:id]
    @questions = user.questions if user
  end
  
  def answered
    user = User.find params[:id]
    if user
      @questions = Question.find_by_sql("select * from questions where id in (select question_id from answers where user_id = #{user.id})")
    end
  end
end
