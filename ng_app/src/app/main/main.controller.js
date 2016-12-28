(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('MainController', MainController);

  /** @ngInject */
  function MainController($state, $cookies, Restangular) {
    var vm = this

    vm.logout = function(){
      Restangular.one('sessions').remove().then(function(result) {
        $cookies.remove('user_email');
        $cookies.remove('user_token');
        $state.go("login")
      },function(error) {
        $log.info(error.data.message)
        alert(error.data.message)
      });
    }

    vm.loggedIn =function(){
      return $state.current.name == "home"
    }
  }
})();
