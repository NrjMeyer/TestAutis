var App = function () {

  'use strict';

  var subscriberTypeSelect = $('#subscriber-type');

  var init = function () {

    _initSelects();

  };

  var _initSelects = function () {

    subscriberTypeSelect.dropkick({mobile:true});

  };

  init();

  return {
    init: init
  };

};
