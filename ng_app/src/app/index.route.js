(function() {
  'use strict';

  angular
    .module('ngApp')
    .config(routerConfig);

  /** @ngInject */
  function routerConfig($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('login', {
        url: '/login',
        templateUrl: 'app/sessions/login.html',
        controller: 'SessionsController',
        controllerAs: 'sessions'
      })
      .state('home', {
        url: '/',
        templateUrl: 'app/home/index.html',
        controller: 'HomeController',
        controllerAs: 'home'
      })

    $urlRouterProvider.otherwise('/');
  }

})();
