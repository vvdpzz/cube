$redis = Redis.new(:host => 'localhost', :port => 6379)

Resque.redis = $redis

class Redis
  def self.front(l)
    $redis.lrange(l, 0, 0).first
  end

  def self.back(l)
    $redis.lrange(l, -1, -1).first
  end

  def self.push_front(l, e)
    $redis.lpush l, e
  end

  def self.push_back(l, e)
    $redis.rpush l, e
  end

  def self.incr(c)
    $redis.incr c
  end

  def self.zadd(k, m)
    $redis.zadd(k, 0, m)
  end
  
  def self.vote_hash(type, id)
    "#{type}:#{id}:vote"
  end
end
