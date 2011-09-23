class UUIDList
  def self.pop
    list = 'UUIDList'
    $redis = Redis.new(:host => 'localhost', :port => 6379)
    $redis.multi do
      if $redis.llen(list).to_i <= 100
        1000.times do
          uuid = ''
          2.times{uuid+=UUIDTools::UUID.random_create.to_i.to_s[0..7]}
          $redis.rpush(list, uuid)
        end
      end
      return $redis.lpop(list)
    end
  end
end
