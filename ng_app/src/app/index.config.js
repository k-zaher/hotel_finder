(function() {
  'use strict';

  angular
    .module('ngApp')
    .config(config);

  /** @ngInject */
  function config($logProvider, toastrConfig, $httpProvider, RestangularProvider) {
    // Enable log
    $logProvider.debugEnabled(true);

    // Set options third-party lib
    toastrConfig.allowHtml = true;
    toastrConfig.timeOut = 3000;
    toastrConfig.positionClass = 'toast-top-right';
    toastrConfig.preventDuplicates = true;
    toastrConfig.progressBar = true;

    $httpProvider.interceptors.push(function($q, $cookies,$location) {
      return {
        'request': function(config) {
          config.headers['X-USER-EMAIL'] = $cookies.get("user_email");
          config.headers['X-USER-TOKEN'] = $cookies.get("user_token");
          return config;
        },
        'responseError': function(response) {
          if (response.status == 401) {
            $location.path('/login');
            $cookies.remove('user_email');
            $cookies.remove('user_token');
          }
          if (response.status == 406) {
            $location.path('/login');
            $cookies.remove('user_email');
            $cookies.remove('user_token');
          }
          return $q.reject(response);
        }
      };
    });

    RestangularProvider.setBaseUrl('http://localhost:3000/api/v1/');
    RestangularProvider.setDefaultRequestParams({format: "json"});
  }

})();
