(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('HomeController', HomeController);

  /** @ngInject */
  function HomeController($scope, Restangular, $log, $state, $cookies, $uibModal) {
    var vm = this

    vm.systemMsg = "Hello"
    console.log("HI")

    if (navigator.geolocation) {
      vm.systemMsg = "Getting Location *********************************"
      navigator.geolocation.getCurrentPosition(function(position){
        console.log(position)
        $scope.$apply(function(){
          console.log(position)
          vm.lat = position.coords.latitude;
          vm.long = position.coords.longitude;
          vm.systemMsg = "Getting Hotels *********************************"
          getHotels()
        });
      });
    }


    function getHotels(){
      Restangular.all('hotels').getList({lat: vm.lat, long: vm.long}).then(function(result) {
        vm.hotels = result
      },function(error) {
          $log.info(error.data.message)
          alert(error.data.message)
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
  }
})();
