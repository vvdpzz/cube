class Notification < ActiveRecord::Base

  # 1  问 题 有 了 新 答 案
  def self.notif_new_answer
    hash = {}
    hash[:answer_id]   = answer_id
    hash[:message]     = 'You have a new answer'
    
    Notification.create(
    :receiver_id     => receiver_id,
    :description     => hash
    )
    
     Pusher["presence-channel_#{receiver_id}"].trigger('notification_created', (notification.serializable_hash).to_json)
  end
  
  # 2  问 题 有 了 新 评 论
  def self.notif_new_a_comment
    hash = {}
    hash[:answer_id]   = answer_id
    hash[:message]     = 'You have a new comment'
    
    Notification.create(
    :receiver_id     => receiver_id,
    :description     => hash
    )
  end
  
  # 3  答 案 有 了 新 评 论
  def self.notif_new_q_comment
    hash = {}
    hash[:question_id]   = question_id
    hash[:message]     = 'You have a new comment'
    
    Notification.create(
    :receiver_id     => receiver_id,
    :description     => hash
    )  
  end
  
  # 4  答 案 被 接 受
  def self.notif_answer_accepted ()
    hash = {}
    hash[:question_id]   = question_id
    hash[:message]     = 'You answer has been accepted'
    
    Notification.create(
    :receiver_id     => receiver_id,
    :description     => hash
    )
  end
  
  # 5  用 户 被 关 注
  def self.notif_new_follower ()
    hash = {}
    hash[:follower_id]   = follower_id
    hash[:follower_name] = follower_name
    hash[:message]     = 'You have a new follower'
    
    Notification.create(
    :receiver_id     => receiver_id,
    :description     => hash
    )
  end
  
  # 6 new message
  def self.notif_new_message (receiver_id, sender_id, sender_name)
    hash = {}
    hash[:sender_id]   = sender_id
    hash[:sender_name] = sender_name
    hash[:message]     = 'You have a new message'
    
    Notification.create(
    :receiver_id     => receiver_id,
    :description     => hash
    )
  end
end
