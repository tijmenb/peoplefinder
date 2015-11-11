require 'yaml'

data_file = Rails.root.join('db', 'seeds', 'data', 'cities.yml')
cities   = YAML.load_file(data_file)

cities.each do |city|
  City.find_or_create_by(name: city)
end
