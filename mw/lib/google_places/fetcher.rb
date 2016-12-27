require 'rubygems'
require 'open-uri'
require 'json'

module GooglePlaces
  module Fetcher
    class << self
      PLACESBASEURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?".freeze

      def run(lat, long)
        Rails.cache.fetch("places/#{lat}/#{long}", expires_in: 12.hours) do
          puts "hello"
          result = open(prepare_url(lat, long)) do |file|
            JSON.parse(file.read)
          end
          result["results"].map { |obj| GooglePlaces::Serializer.format(obj) }
        end
      end

      private

      def prepare_url(lat, long)
        radius = 10000.to_s
        type = 'lodging'
        key = Rails.application.secrets.google_places_key
        PLACESBASEURL + 'location=' + lat + ',' + long  + '&' + 'radius=' + radius + '&' + "type=" + type + '&' + "key=" + key
      end
    end
  end
end