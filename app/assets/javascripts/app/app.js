var App = function () {

  'use strict';

  var subscriberTypeSelect = $('#subscriber-type');

  var init = function () {

    _initEvents();
    _initSelects();

    $('.testinput').on('change', function () {
      console.log('lol');
    });

    $('.input__classic').on('input', function () {
      console.log('mdrrr');
    });

  };

  var _initEvents = function () {

    // $(window).on('scroll', $.proxy(_checkCurrentSection, this));

  };

  var _initSelects = function () {

    subscriberTypeSelect.dropkick({mobile:true});

  };

  init();

  return {
    init: init
  };

};
