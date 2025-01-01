require 'net/http'
require 'uri'
require 'json'

class RemoveGists
  def initialize(token)
    @token = token
    @base_url = 'https://api.github.com/gists'
  end

  def bulk_delete
    gists = fetch_gists
    return unless gists

    gists.each do |gist|
      delete_gist(gist['id'])
    end
  end

  def fetch_gists
    uri = URI(@base_url)
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{@token}"
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  end

  def delete_gist(gist_id)
    uri = URI("#{@base_url}/#{gist_id}")
    req = Net::HTTP::Delete.new(uri)
    req['Authorization'] = "Bearer #{@token}"
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    res.code == '204'
  end
end
