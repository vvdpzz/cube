# coding: UTF-8

User.create(:username => 'xxd', :realname => '薛晓东', :email => 'xuexiaodong79@gmail.com', :password => 'xxdxxd')
User.create(:username => 'vvdpzz', :realname => '陈振宇', :email => 'vvdpzz@gmail.com', :password => 'vvdpzz')
User.create(:username => 'tzzzoz', :realname => '喻柏程', :email => 'tzzzoz@gmail.com', :password => 'tzzzoz')

# read vote data into redis
# $redis.multi do
#   Vote.select("user_id, question_id, answer_id").each do |vote|
#     if vote.question_id
#       $redis.hset(Redis.vote_hash("question", vote.question_id), vote.user_id, vote.value)
#     elsif vote.answer_id
#       $redis.hset(Redis.vote_hash("answer", vote.answer_id), vote.user_id, vote.value)
#     end
#   end
# end