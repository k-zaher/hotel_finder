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

    $httpProvider.interceptors.push(function($cookies) {
      return {
        'request': function(config) {
          config.headers['X-USER-EMAIL'] = $cookies.get("user_email");
          config.headers['X-USER-TOKEN'] = $cookies.get("user_token");
          return config;
        }
      };
    });

    RestangularProvider.setBaseUrl('http://localhost:3000/api/v1/');
  }

})();
