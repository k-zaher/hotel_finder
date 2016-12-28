# Hotel Finder
Conichi Hotel Finder Challenge

[![Code Climate](https://codeclimate.com/github/kimooz/hotel_finder/badges/gpa.svg)](https://codeclimate.com/github/kimooz/hotel_finder)
[![Build Status](https://travis-ci.org/kimooz/hotel_finder.svg?branch=master)](https://travis-ci.org/kimooz/hotel_finder)

The Project consists of a rails API app (MW) and an angular app that consumes the API provided by the MW.

The **ClientApp** simply **authenticates** the user using `email` and `password`, then **requests access** to get the user location. If the access to the location is permitted, it collects the Longitude and Latitude and sends it to the **mw**, If not permitted it falls back to a simple input which autocompletes the city name to get the Longitude and Latitude of a given city and sends it to the **mw**. If the user selects a hotel, a modal opens to get some details and then creates a fake booking. 

The **MW** app simply connects to **Google Places API** to get hotels and cache the response. It also provides **authenticated** APIs to create a booking and **public** API's to list all bookings on the system and all bookings for a specific user.

## Stack

* Ruby: 2.2.2
* Rails: 5.1
* Postgresql
* Rspec
* Redis
* Angular: 1.5.3
* Gulp
* Jade

## Notes

* MW only accepts JSON requests and falls back to 406 if not JSON

* Public API to get Bookings for user, I suggest that it should be in users controller under 'bookings' action instead of being in the bookings controller under 'for_user' action, However I did that as it was suggested by the challenge that the API url should be /booking/:user__id

## Stories

* As a user, I can login with my email and password.
* As a user, I can accept the browser request to get my current GPS location.
* As a user, I can search by city name using autocomple, if the browser failed to get my current location.
* As a user, I should see a list of the closest 20 hotels to my location.
* As a user, I can book a hotel with following inputs `Guest Name`, `Bed Preference`, `Checkin time` and `Checkout time`.
* As a user, I can't have any overlapped bookings.
* As a user, I can log out. 

## Model Structure
The MW app consists of four models:

* User
	* Interfaces Devise `database_authenticatable`, `trackable` and `validatable` modules
	* Adds ":token_authenticatable" module to device using Tiddle Gem
	* has_many `bookings`
	* has_many `authentication_tokens`
* AuthenticationToken
	* belongs_to `user`
	* Stores a token for each user client to be used to authentication
* Booking
   * belongs_to `user`
   * belongs_to `hotel`
   * validates that the checkin date is not after the checkout date
   * validates that the user doesn't book multiple bookings with the same dates
* Hotel
   * has_many `bookings`
   * It acts as a cache for booked hotels
   * It stores a pid which is the google place id to update info later on

## API
API is namespaced under "api" and then versioned for "v1"

`/api/v1/[:controller]`

API uses Token Authentication where it expects X-USER-EMAIL and X-USER-TOKEN as headers of every request which requires authentication

All Controllers under v1 inherit form Api::BaseController which does the following actions before routing the request to the controller: 

* **check_format**: Makes sure that the incoming request is a json request and falls back to a 406 response.
* **authenticate_user!**: Authenticates the user by checking the headers and fallbacks to a 401 response

Note: API::V1::SessionsController skips authenticate_user! 

The mw has two public API's to get all bookings and user related bookings

* `api/v1/bookings`
* `api/v1/bookings/[user_id]`


URL: `/bookings`
Response: 
 `
 	
 	[
	  {
	    "id": 21,
	    "guest_name": "Kareem Diaa",
	    "hotel_name": "JW Marriott Hotel Cairo",
	    "hotel_pid": "deb52b6273d7b785fd903a272846c543f8f5a0ea",
	    "preference": "king_bed",
	    "checkin_date": "2016-12-28",
	    "checkout_date": "2016-12-30",
	    "user": {
	      "id": 1,
	      "name": "Kaleb Adams Jr.",
	      "email": "carrie@rutherfordschmitt.net"
	    }
	  },
	  {
	    "id": 22,
	    "guest_name": "Kane MC",
	    "hotel_name": "JW Marriott Hotel Cairo",
	    "hotel_pid": "deb52b6273d7b785fd903a272846c543f8f5a0ea",
	    "preference": "king_bed",
	    "checkin_date": "2016-12-30",
	    "checkout_date": "2016-12-31",
	    "user": {
	      "id": 2,
	      "name": "Sam Adams",
	      "email": "sam@rutherfordschmitt.net"
	    }
	  }
	]`

URL: `/bookings/2`
Response: 
 `
 
 	[
 	  {
	    "id": 22,
	    "guest_name": "Kane MC",
	    "hotel_name": "JW Marriott Hotel Cairo",
	    "hotel_pid": "deb52b6273d7b785fd903a272846c543f8f5a0ea",
	    "preference": "king_bed",
	    "checkin_date": "2016-12-30",
	    "checkout_date": "2016-12-31",
	    "user": {
	      "id": 2,
	      "name": "Sam Adams",
	      "email": "sam@rutherfordschmitt.net"
	    }
	  }
	]`


## Hotel Fetcher

I have decided to use Google Places API as suggested by the challenge requirments.

I have built `GooglePlaces::Fetcher` which consumes the google places api and is located in /lib/google_places/fetcher.rb.

`GooglePlaces::Fetcher` simply gets the user long and lat as inputs and sends an API to google places to get all places with type **lodging** and radius **10,000**

The data coming from Google places is very ugly, so I decided to serialize the data in a clean format to be used by the client app using `GooglePlaces::Serializer`.

I wanted also to display a photo of the hotel for a better UI so I took the photo-reference coming from the google places API and built a photo url using the google places photos API to be called by the client app.

I have also decided to cache the response coming from the google places API due to request limits. I have set the app default cache store to redis and used it to cache the response and gave it a TTL of 12 hours.

## Developmemt

`git clone https://github.com/kimooz/hotel_finder.git`

### MW

`cd [project]/mw`

* `bundle`
* Setup your database.yml
* `rails db:setup db:seed`
* `rails s`

Note: while seeding, the system will print 10 emails to use for testing with 'test@1234' as password for all.

### Tests

run `rspec`

### Angular

`cd [project]/ng_app`

* `npm install`
* `bower install`
* `gulp serve`

### Demo
* ***The Login View***

![Login View](https://s30.postimg.org/u5fuabkep/Screen_Shot_2016_12_28_at_10_25_29_PM.png)

* ***If the user allowed the browser to get the location it will get the hotels around this location***

![Hotels with html5 GeoLocation](https://s30.postimg.org/mdz4brg9d/Screen_Shot_2016_12_28_at_10_25_56_PM.png)

* ***If the browser failed to get the user location or it was not allowed an input text appears to enter the city***

![Select City](https://s30.postimg.org/5srhw3p5d/Screen_Shot_2016_12_28_at_10_26_30_PM.png)

* ***I Have requested to get hotels in Amsterdam***

![Amsterdam Hotels](https://s30.postimg.org/hvwtjo07l/Screen_Shot_2016_12_28_at_10_26_42_PM.png)

* ***The booking form***

![Booking Form](https://s30.postimg.org/i64c30ett/Screen_Shot_2016_12_28_at_10_26_15_PM.png)

***I have deployed the ng app on bitballon and the mw on heroku You can play with it using the following urls:***

* ***FrontEnd:*** [https://conichi-hotel.bitballoon.com/#/](https://conichi-hotel.bitballoon.com/#/)
* ***BackEnd*** [https://conichi-mw.herokuapp.com/](https://conichi-mw.herokuapp.com/)



##TODO##

* Require HTTPS

* Add Pagination for hotels

* Add Pagination for Public API's

* Sort Hotels by Ratings


**Enjoy!**
