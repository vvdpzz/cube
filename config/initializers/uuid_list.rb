class UUIDList
  def self.pop
    uuid = 'UUIDList'
    $redis.multi do
      if $redis.llen uuid <= 100
        1000.times do
          uuid = ''
          2.times{uuid+=UUIDTools::UUID.random_create.to_i.to_s[0..7]}
          $redis.rpush queue, uuid
        end
      end
      return $redis.lpop queue
    end
  end
end