module CitiesHelper
  extend ActiveSupport::Concern

  included do
    before do
      load './db/seeds/cities.rb'
    end
  end
end
