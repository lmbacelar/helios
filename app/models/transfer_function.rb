class TransferFunction < ActiveRecord::Base
  self.abstract_class = true
end

require 'iec60751_function'
require 'its90_function'
