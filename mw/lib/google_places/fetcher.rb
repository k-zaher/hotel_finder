require 'rubygems'
require 'open-uri'
require 'json'
# Interfaces Google Places
module GooglePlaces::Fetcher
  class << self
    PLACESBASEURL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'.freeze

    def run(lat, long)
      url = prepare_url(lat, long, 'lodging', 10_000.to_s)
      Rails.cache.fetch("places/#{lat}/#{long}", expires_in: 12.hours) do
        result = open(url) do |file|
          JSON.parse(file.read)
        end
        result['results'].map { |obj| GooglePlaces::Serializer.format(obj) }
      end
    end

    private

    def prepare_url(lat, long, type, radius)
      url = PLACESBASEURL
      url += 'location=' + lat + ',' + long
      url += '&' + 'radius=' + radius
      url += '&' + 'type=' + type
      url += '&' + 'key=' + Rails.application.secrets.google_places_key
      url
    end
  end
end
