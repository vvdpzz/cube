class Mail < ActiveRecord::Base
  def self.strong_mail_insert(batch_id, sender_id, sender_name, receiver_id, receiver_name, title, content, redis_mail) 
    ActiveRecord::Base.connection.execute("call sp_strong_mail_insert(#{batch_id}, #{sender_id}, '#{sender_name}', #{receiver_id}, '#{receiver_name}', '#{title}', '#{content}', '#{redis_mail}')")
  end
end
