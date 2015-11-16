module BuildingsHelper
  extend ActiveSupport::Concern

  included do
    before do
      load './db/seeds/buildings.rb'
    end
  end
end
