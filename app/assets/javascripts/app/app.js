var App = function () {

  'use strict';

  var burgerMenu           = $('.header__burger');
  var menu                 = $('.menu');
  var subscriberTypeSelect = $('#subscriber-type');

  var init = function () {

    _initEvents();
    _initSelects();

  };

  var _initEvents = function () {

    if ($(window).width() < 1024) {
      burgerMenu.on('click', _toggleMenu);
    }

  };

  var _toggleMenu = function () {

    $('body').toggleClass('disable-scrolling');
    burgerMenu.toggleClass('active');
    menu.toggleClass('active');

  };

  var _initSelects = function () {

    subscriberTypeSelect.dropkick({mobile:true});

  };

  init();

  return {
    init: init
  };

};
