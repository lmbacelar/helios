module RetryMethods
  def retry_on_exception ex, n = 1, &block
    begin
      count = 1
      block.call
    rescue ex
      if count <= n
        count+= 1
        retry
      else
        raise
      end
    end
  end

  def save_and_retry_on_unique *args
    retry_on_exception ActiveRecord::RecordNotUnique do
      save *args
    end
  end
end
