require 'net/http'
require 'uri'
require 'json'

class ThirdPartyNotifier
  def self.notify(message, state)
    Rails.application.config.third_party_endpoints.each do |endpoint|
      uri = URI.parse(endpoint)
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request.body = { message: message, state: state, authenticity_token: authenticity_token(message) }.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.schems == 'https') do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.error("Failed to notify #{endpoint}: #{response.body}")
      end
    end
  end

  def self.authenticity_token(message)
    secret = Rails.application.secret_key_base
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, message.to_json)
  end
end