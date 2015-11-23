require 'yaml'

data_file = Rails.root.join('db', 'seeds', 'data', 'policies.yml')
policies   = YAML.load_file(data_file)

policies.each do |p|
  Policy.where(name: p['name']).first_or_create.tap do |policy|
    policy.allowed_to = p['allowed_to']
    policy.save
  end
end
