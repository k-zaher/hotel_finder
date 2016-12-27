(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('BookingModalController', BookingModalController);

  /** @ngInject */
  function BookingModalController(params, Restangular, $log) {
    var vm = this

    vm.hotel = params

    vm.preferences = [{name:"King Bed", value: 0}, {name:"Single Bed", value: 1}]

    vm.today = function() {
      vm.dt = new Date();
    };

    vm.submitBooking = function(form){
      if(!form || !form.guest_name || !form.preference || !form.checkin_date || !form.checkout_date){
        alert("All Fields are required")
        return
      }
      if(form.checkin_date > form.checkout_date){
        alert("Checkout Date should be after Checkin Date")
        return
      }
      form.preference = parseInt(form.preference)
      Restangular.all('bookings').post({
        hotel: vm.hotel,
        booking: form
      }).then(function(result) {
          alert("Booking Added Successfully")
      },function(error) {
          $log.info(error.data.message)
          alert(error.data.message)
      });
    }

    vm.today();

    vm.inlineOptions = {
      customClass: getDayClass,
      minDate: new Date(),
      showWeeks: true
    };

    vm.dateOptions = {
      formatYear: 'yy',
      initDate: new Date(),
      maxDate: new Date(2022, 12, 1),
      minDate: new Date(),
      startingDay: 1
    };


    vm.open1 = function() {
      vm.popup1.opened = true;
    };

    vm.open2 = function() {
      vm.popup2.opened = true;
    };

    vm.setDate = function(year, month, day) {
      vm.dt = new Date(year, month, day);
    };

    vm.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate'];
    vm.format = vm.formats[0];
    vm.altInputFormats = ['M!/d!/yyyy'];

    vm.popup1 = {
      opened: false
    };

    vm.popup2 = {
      opened: false
    };

    var tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    var afterTomorrow = new Date();
    afterTomorrow.setDate(tomorrow.getDate() + 1);
    vm.events = [
      {
        date: tomorrow,
        status: 'full'
      },
      {
        date: afterTomorrow,
        status: 'partially'
      }
    ];

    function getDayClass(data) {
      var date = data.date,
        mode = data.mode;
      if (mode === 'day') {
        var dayToCheck = new Date(date).setHours(0,0,0,0);

        for (var i = 0; i < vm.events.length; i++) {
          var currentDay = new Date($scope.events[i].date).setHours(0,0,0,0);

          if (dayToCheck === currentDay) {
            return $scope.events[i].status;
          }
        }
      }

      return '';
    }
  }
})();
