class Building < ActiveRecord::Base
  scope :by_name, ->{ order :address }

  def to_human
    self.address
  end
end
