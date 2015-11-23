class Policy < ActiveRecord::Base
  serialize :allowed_to, Array
end
