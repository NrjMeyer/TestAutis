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

  // Display sections variables
  var firstSectionInputs  = $('.formule-input');
  var secondSectionInputs = $('.option-input');
  var thirdSectionInputs = $('.info-input');

  var init = function () {

    _initEvents();
    _highlightSection();
    _checkThirdSection();

  };

  var _initEvents = function () {

    sidebarItems.on('click', $.proxy(_goToSection, this));

    firstSectionInputs.on('change', function(){_displaySection(1)});
    secondSectionInputs.on('change', function(){_displaySection(2)});

  };

  var _goToSection = function (e) {

    var target = $(e.target),
        targetIndex = target.index();

    if (target.hasClass('sidebar__item--disabled') || targetIndex === 4) return;

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

  var _checkThirdSection = function () {

    thirdSectionInputs.on('change input', throttle(function () {
      console.log('throttled my friend');
      var empty = thirdSectionInputs.filter(function () {
        return this.value === "";
      });

      if (empty.length === 0 && paymentSection.hasClass('hidden')) {
        _displaySection(3);
      }
    }, 500));

  };

  var _displaySection = function (number) {

    var current = allSections[number];

    if ($(current).hasClass('visible')) return;

    $(current).removeClass('hidden').addClass('visible');

    sidebarItems.eq(number).removeClass('sidebar__item--disabled');

    Waypoint.refreshAll();

    _resetVariables();

  };

  var _resetVariables = function () {

    offsetChoice  = choiceSection.offset().top;
    offsetOptions = optionsSection.offset().top;
    offsetInfos   = infosSection.offset().top;
    offsetPayment = paymentSection.offset().top;

    offsets = [offsetChoice, offsetOptions, offsetInfos, offsetPayment];

  };

  init();

  return {
    init: init
  };

};
