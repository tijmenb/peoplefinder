require 'yaml'

data_file = Rails.root.join('db', 'seeds', 'data', 'buildings.yml')
buildings   = YAML.load_file(data_file)

buildings.each do |building|
  Building.find_or_create_by(address: building)
end
