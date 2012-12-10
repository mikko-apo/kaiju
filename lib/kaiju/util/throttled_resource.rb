class ThrottledResource
  def initialize(max=2)
    @max = max
    @count = 0
    @mutex = Mutex.new
    @queue = []
    @queue_cv = ConditionVariable.new
    Thread.new do
      @mutex.synchronize do
        while true
          if @queue.empty? || @queue.size > 0 && @count == @max
            puts "queue was empty or count was at max, waiting for something to do"
            @queue_cv.wait(@mutex)
            puts "woke up"
          else
            puts "removing task from queue and starting it"
            @count += 1
            task_cv = @queue.delete_at(0)
            task_cv.broadcast
          end
        end
      end
    end
  end

  def throttle(&block)
    @mutex.synchronize do
      puts "add new task to queue"
      my_cv = ConditionVariable.new
      @queue << my_cv
      @queue_cv.broadcast
      my_cv.wait(@mutex)
      puts "starting task"
    end
    begin
      return block.call
    ensure
      @mutex.synchronize do
        @count -= 1
        @queue_cv.broadcast
      end
    end
  end
end
