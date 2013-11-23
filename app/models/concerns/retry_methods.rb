module RetryMethods
  def retry_on_error er, n = 1, &block
    count = 1
    begin
      block.call
    rescue er
      count+= 1 and retry if count <= n
      raise
    end
  end

  def save_and_retry_on_unique *args
    retry_on_error ActiveRecord::RecordNotUnique do
      save *args
    end
  end
end
