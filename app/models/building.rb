class Building < ActiveRecord::Base
  scope :by_name, ->{ order :address }
end
