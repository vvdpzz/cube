class MailsController < ApplicationController
  # POST /mailsent
  def create
    sender     = User.select("id,realname,email").where(:id => current_user.id)
    receiver   = User.select("id,realname,email").where(:id => params[:receiver_id])

    batch_id        = $redis.incr('batch_id') 
    sender_id       = sender.first.id
    sender_name     = sender.first.realname
    #sender_image   = sender.first.gravatar_url(:size => 32)
    receiver_id     = receiver.first.id
    receiver_name   = receiver.first.realname
    #receiver_image  = receiver.first.gravatar_url(:size => 32)
    title           = params[:title]
    content         = params[:content]
    created_at      = t
    redis_mail      = "l_mail:#{current_user.id}.#{params[:receiver_id]}.#{batch_id}"
    t               = Time.now
    
    if sender != receiver
      hash = {}
      hash = {
        :sender_id      => sender_id,
        :sender_name    => sender_name,
       # :sender_image   => sender_image,
        :receiver_id    => receiver_id, 
        :receiver_name  => receiver_name, 
        #:receiver_image => receiver_image,
        :title          => title,
        :content        => content, 
        :time           => t}
      
      into_db = Mail.strong_mail_insert(batch_id, sender_id, sender_name, receiver_id, receiver_name, title, content, redis_mail) 
      #into_db = Mail.strong_mail_insert(batch_id, sender_id, sender_name, sender_image, receiver_id, receiver_name, receiver_image, title, content, redis_mail) 
      if into_db
        $redis.lpush(redis_mail, MultiJson.encode(hash))
        #$redis.zadd("z_mail:between.#{current_user.id}.#{params[:receiver_id]}.#{batch_id}", batch_id, MultiJson.encode(hash))
        $redis.lpush("l_inbox_#{current_user.id}",redis_mail)
        $redis.lpush("l_inbox_#{receiver_id.id}",redis_mail)
      end
    end
    respond_to do |format|
      format.json { render :json => hash, :status => :created }
    end
  end
  
  # POST /mailreplied
  def reply
    mail = Mail.where(:id => params[:mail_id])
    redis_mail = mail.first.redis_mail
    t = Time.now
    hash = {}
    hash = {:sender_id      => mail.first.receiver_id,
            :sender_name    => mail.first.receiver_name,
            :sender_image   => mail.first.receiver_image,
            :receiver_id    => mail.first.sender_id,
            :receiver_name  => mail.first.sender_name,
            :receiver_image => mail.first.sender_image,
            :title          => mail.first.title,
            :content        => params[:content],
            :time           => t}

    Mail.create(:batch_id       => mail.first.batch_id,
    :sender_id      => mail.first.receiver_id,
    :sender_name    => mail.first.receiver_name,
    :sender_image   => mail.first.receiver_image,
    :receiver_id    => mail.first.sender_id,
    :receiver_name  => mail.first.sender_name,
    :receiver_image => mail.first.sender_image,
    :title          => mail.first.title,
    :content        => params[:content],
    :created_at     => t,
    :redis_mail     => mail.first.redis_mail)
    
    #$redis.zadd("z_mail:between.#{mail.first.sender_id}.#{current_user.id}.#{mail.first.batch_id}", mail.first.batch_id, MultiJson.encode(hash))
    $redis.lpush(redis_mail, MultiJson.encode(hash))
    
    respond_to do |format|
      format.json { render :json => hash, :status => :created }
    end
  end

  # GET /mails/:batch_id
  def view
    
    batch_id = params[:batch_id]
    mails = $redis.KEYS("l_mail:*.#{batch_id}").first
    #hash = mails.collect{|mail| $redis.ZRANGE("#{mail}",0,-1)} 
    batch = $redis.LRANGE("#{mails}",0,-1) 
    #hash = MultiJson.encode batch
    if not batch
      #mail = Mail.select("id,title").find_by_batch_id params[:batch_id]
    end
    
    respond_to do |format|
      format.json { render :json => batch }
    end
  end
  
  # GET /mails/inbox
  def inbox
    mails = $redis.LRANGE("l_inbox_#{current_user.id}",0,-1)
    #mails = MultiJson.encode(mails)
    if not mails
      mails = MailInbox.select('redis_mail').where(:user_id => current_user.id)
      #mails = MultiJson.encode(mails)
      #TODO: how to get the second part of this string "[{\"redis_mail\":\"l_mail:1.2.16\"}]" ?
    end
    respond_to do |format|
      format.json { render :json => {:mails => mails } }
    end
  end  
  
  def renew
    mail = Mail.where(:id => params[:id])
    @sender_id = mail.first.sender_id
    @sender_image = mail.first.sender_image
    @mail_id = mail.first.id
  end
end
