(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('HomeController', HomeController);

  /** @ngInject */
  function HomeController($scope, Restangular, $log, $state, $cookies, $uibModal) {
    var vm = this
    vm.addressOptions = {types: ['(cities)']}
    vm.systemMsg = "Hello"
    vm.geoLocation = true
    vm.position = {}

    if (navigator.geolocation) {
      vm.systemMsg = "Getting Location From Browser"
      navigator.geolocation.getCurrentPosition(showPosition, errorPosition)
    }

    function showPosition(position){
      $scope.$apply(function(){
        vm.position.lat = position.coords.latitude;
        vm.position.long = position.coords.longitude;
      });
    }

    function errorPosition(){
      console.log("Error Getting Location")
      $scope.$apply(function(){
        vm.geoLocation = false
        vm.systemMsg = "Failed to Get Location, Please Select your city"
      });
    }


    function getHotels(){
      vm.systemMsg = "Getting Hotels *********************************"
      Restangular.all('hotels').getList({lat: vm.position.lat, long: vm.position.long}).then(function(result) {
        vm.hotels = result
        vm.systemMsg = "Enjoy :)"
      },function(error) {
          $log.info(error)
      });
    }

    vm.openBookingModal = function(hotel) {
      return $uibModal.open({
        animation: true,
        templateUrl: 'app/components/booking_modal/form.html',
        controller: 'BookingModalController as booking',
        size: "lg",
        resolve: {
          params: function() {
            return hotel;
          }
        }
      });
    }

    $scope.$watch(
        "home.position.long",
        function handleFooChange( newValue, oldValue ) {
          if (newValue){
            getHotels()
          }
        }
    );
  }
})();
