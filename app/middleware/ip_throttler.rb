class IpThrottler

  REQ_PER_MIN = 5

  def initialize(app)
    @app = app
  end

  def call(env)
    # return [200, {'Content-Type'=> 'text/plain'},  ]
    Rails.logger.warn("here")
    addr =  env["REMOTE_ADDR"]
    if self.class.restrict?(addr)
      time = self.class.current_count_for(addr)
      body = "You are blocked for #{time} times"
      [200, {'Content-Type'=> 'text/plain', 'Content-Length' => body.length.to_s}, [body]]
    else
      @app.call(env)
    end
  end

  private
  cattr_accessor :cache
  cattr_accessor :count
  self.cache = Dalli::Client.new("127.0.0.1:11211")
  self.count = 0
  
  def self.restrict?(ip_addr)
    begin
      track(ip_addr)
      current_count_for(ip_addr) > REQ_PER_MIN
    rescue Dalli::RingError
      false
    end
  end

  def self.current_count_for(ip_addr)
    # (cache.get(ip_addr) || 0).to_i
    self.count
  end

  def self.track(ip_addr)
    # cache.add(ip_addr, "0", 1.minute.from_now.to_i, :raw => true) unless cache.get(ip_addr)
    #     cache.incr(ip_addr)
    self.count = self.count + 1
  end
end
