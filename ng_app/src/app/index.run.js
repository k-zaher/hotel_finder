(function() {
  'use strict';

  angular
    .module('ngApp')
    .run(runBlock);

  /** @ngInject */
  function runBlock($log, $cookies, $http, $location) {
    if ($cookies.get('user_token')) {
      if ($location.path() == "/login"){
        $location.path('/home');
      }
    }else{
      $location.path('/login');
    }
  }

})();
