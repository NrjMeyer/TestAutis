var Sidebar = function () {

  'use strict';

  var sidebarItems  = $('.sidebar__item');

  var allSections    = $('.js-section');
  var choiceSection  = $('.choice');
  var optionsSection = $('.options');
  var infosSection   = $('.informations');
  var paymentSection = $('.payment');

  var offsetChoice  = choiceSection.offset().top;
  var offsetOptions = optionsSection.offset().top;
  var offsetInfos   = infosSection.offset().top;
  var offsetPayment = paymentSection.offset().top;

  var offsets = [offsetChoice, offsetOptions, offsetInfos, offsetPayment];

  var init = function () {

    _initEvents();
    _highlightSection();

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

  var _highlightSection = function () {

    var onScrollDown = allSections.waypoint(function (direction) {

        if (direction === 'down') {
          var index = $(this.element).index() - 1;

          sidebarItems.removeClass('sidebar__item--current');
          sidebarItems.eq(index).addClass('sidebar__item--current');
        }

      }, {offset: '40%'});

    var onScrollUp = allSections.waypoint(function (direction) {

        if (direction === 'up') {
          var index = $(this.element).index() - 1;

          sidebarItems.removeClass('sidebar__item--current');
          sidebarItems.eq(index).addClass('sidebar__item--current');
        }

      }, {offset: '1%'});

  };

  init();

  return {
    init: init
  };

};
