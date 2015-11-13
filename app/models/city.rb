class City < ActiveRecord::Base
  scope :by_name, ->{ order :name }

  def to_human
    self.name
  end
end
