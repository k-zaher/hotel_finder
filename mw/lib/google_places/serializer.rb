module GooglePlaces
  module Serializer
    class <<  self
      PHOTOBASEURL = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400'.freeze

      def format(data)
        {
          name: data["name"],
          id: data["id"],
          rating: data["rating"],
          photo_url: get_photo_url(data["photos"])
        }
      end
      private

      def get_photo_url(photos_array)
        key = Rails.application.secrets.google_places_key
        return 'http://www.hotel-r.net/im/hotel/asia/hk/hotel-icon-0.jpg' if !photos_array
        return PHOTOBASEURL + '&photoreference=' + photos_array[0]["photo_reference"] + "&key=#{key}"
      end
    end
  end
end
