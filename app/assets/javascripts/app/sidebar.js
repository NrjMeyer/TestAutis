var Sidebar = function () {

  'use strict';

  var sidebarItems         = $('.sidebar__item');

  var offsetChoice          = $('.choice').offset().top;
  var offsetOptions         = $('.options').offset().top;
  var offsetInfos           = $('.informations').offset().top;
  var offsetPayment         = $('.payment').offset().top;

  var offsets = [offsetChoice, offsetOptions, offsetInfos, offsetPayment];

  var init = function () {

    _initEvents();

  };

  var _initEvents = function () {

    sidebarItems.on('click', $.proxy(_goToSection, this));

  };

  var _goToSection = function (e) {

    var target = $(e.target),
        targetIndex = target.index();

    if (targetIndex === 4) return;

    $('html, body').animate({
      scrollTop: offsets[targetIndex] - 25
    }, 500);


  };

  init();

  return {
    init: init
  };

};
