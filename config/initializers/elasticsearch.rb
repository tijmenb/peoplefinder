if Rails.env.production? or Rails.env.staging?
  require 'faraday_middleware/aws_signers_v4'

  transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(
    hosts: [{host: ENV['AWS_ELASTICSEARCH_HOST'], port: ENV['AWS_ELASTICSEARCH_PORT']}]
  ) do |faraday|
    faraday.request :aws_signers_v4,
      credentials: Aws::Credentials.new(ENV['AWS_ELASTICSEARCH_KEY'], ENV['AWS_ELASTICSEARCH_SECRET']),
      service_name: 'es',
      region: ENV['AWS_ELASTICSEARCH_REGION']
    faraday.adapter  Faraday.default_adapter
  end

  Elasticsearch::Model.client = Elasticsearch::Client.new(transport: transport)
end
