(function() {
  'use strict';

  angular
    .module('ngApp')
    .controller('SessionsController', SessionsController);

  /** @ngInject */
  function SessionsController($scope, Restangular, $log, $state, $cookies) {
    var vm = this

    vm.handleSignIn = function(loginForm){
      $log.info(loginForm)
      Restangular.all('sessions').post({"user" : loginForm}).then(function(result) {
          $log.info(result.message)
          $cookies.put("user_token", result.authentication_token);
          $cookies.put("user_email", loginForm.email);
          $state.go("home");
      },function(error) {
          $log.info(error.data.message)
          alert(error.data.message)
      });
    }
  }
})();
