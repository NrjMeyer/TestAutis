var App = function () {

  'use strict';

  var $burgerMenu           = $('.header__burger');
  var $menu                 = $('.menu');
  var $subscriberTypeSelect = $('#subscriber-type');
  var $fixedBar             = $('.price-table--fixed');

  var $sidebarItems  = $('.sidebar__item');

  var $allSections    = $('.js-section');
  var $choiceSection  = $('.choice');
  var $optionsSection = $('.options');
  var $infosSection   = $('.informations');
  var $paymentSection = $('.payment');

  var offsetChoice;
  var offsetOptions;
  var offsetInfos;
  var offsetPayment;

  if ($('.main__container').hasClass('js-variables')) {
    offsetChoice  = $choiceSection.offset().top;
    offsetOptions = $optionsSection.offset().top;
    offsetInfos   = $infosSection.offset().top;
    offsetPayment = $paymentSection.offset().top;
  }

  var offsets = [offsetChoice, offsetOptions, offsetInfos, offsetPayment];

  // Display sections variables
  var $firstSectionInputs  = $('.formule-input');
  var $secondSectionInputs = $('.option-input');
  var $thirdSectionInputs  = $('.info-input');

  // Scroll variables
  var sections = [];

  // Update price variables
  var packagePrice  = 0;
  var familyPrice   = 0;
  var familyCount  = 0;
  var donationPrice = 0;
  var totalPrice    = packagePrice + familyPrice + donationPrice;

  // Price sections
  var $priceWithoutPromo    = $('.total-price--withoutPromo');
  var $priceWithPromo       = $('.total-price--withPromo');
  var $subscriptionPrice    = $('.adhesion-price');
  var $familyPriceContainer = $('.family-price');
  var $familyCountContainer = $('.family-count');

  var init = function () {

    _initEvents();
    _fixedElement();
    _initSelects();
    _checkThirdSection();

    if ($(window).width() > 1149) {
      _highlightSection();
    }

    // hide sections
    $('.js-hidden').addClass('hidden');

  };

  var _initEvents = function () {

    if ($(window).width() < 1024) {
      $burgerMenu.on('click', _toggleMenu);
    }

    $(window).on('resize', _fixedElement);

    $sidebarItems.on('click', _goToSection);
    $firstSectionInputs.on('change', function(){_displaySection(1)});
    $secondSectionInputs.on('change', function(){_displaySection(2)});

  };

  var _fixedElement = function () {

    var sectionWidth = $('.options').outerWidth();

    if ($(window).width() > 1149) {
      $fixedBar.css({
        'width': sectionWidth + 'px',
        'margin-left': (-(sectionWidth / 2)) + 90 + 'px'
      });
    }

    if ($(window).width() < 1150) {
      $fixedBar.css({
        'width': sectionWidth + 'px',
        'margin-left': (-(sectionWidth / 2)) + 'px'
      });
    }

  };

  var _toggleMenu = function () {

    $('body').toggleClass('disable-scrolling');
    $burgerMenu.toggleClass('active');
    $menu.toggleClass('active');

  };

  var _initSelects = function () {

    $subscriberTypeSelect.dropkick({mobile:true});

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

    var id = false;
    var scrollId;

    sections.push($('#choice'));

    $(window).on('scroll', throttle(function (e) {
      var scrollTop = $(this).scrollTop() + ($(window).height() / 2);

      for (var i in sections) {
        var section = sections[i];

        if (scrollTop > section.offset().top) {
          scrollId = section.attr('id');
        }
      }

      if (scrollId !== id) {
        id = scrollId;
        $('.js-scroll').removeClass('sidebar__item--current');
        $('.js-scroll[data-section="#'+id+'"]').addClass('sidebar__item--current');
      }

    }, 250));

  };

  var _checkThirdSection = function () {

    $thirdSectionInputs.on('change input', throttle(function () {
      var empty = $thirdSectionInputs.filter(function () {
        return this.value === "";
      });

      if (empty.length === 0 && $paymentSection.hasClass('hidden')) {
        if ($('.main-form').parsley().validate({group: 'block-3'})) {
          _displaySection(3);
          $(window).on('scroll', throttle(_removeFixedElement, 250));
        }
      }
    }, 500));

  };

  var _removeFixedElement = function () {
    if ($fixedBar.offset().top > $('.js-sticky').offset().top) {
      $fixedBar.hide();
    }
  };

  var _displaySection = function (number) {

    var current = $allSections[number];

    if ($(current).hasClass('visible')) return;

    // add section to scroll spy function
    sections.push($(current));

    $(current).removeClass('hidden').addClass('visible fadeInUp');

    if (!$(current).hasClass('informations')) {
      $('html, body').animate({
        scrollTop: $(current).offset().top
      }, 1500);
    }

    $sidebarItems.eq(number).removeClass('sidebar__item--disabled');

  };

  var updateTotalPrice = function (option, price) {
    if (option === 'package') {
      packagePrice = price;
      totalPrice = packagePrice + donationPrice + familyPrice;

      $priceWithoutPromo.html(totalPrice);
      $priceWithPromo.html(totalPrice - (totalPrice * 66/100));
      $subscriptionPrice.html(packagePrice);
    }

    if (option === 'addFamily') {
      familyPrice = price;
      totalPrice = packagePrice + donationPrice + familyPrice;
      familyCount = familyPrice / 12;

      $priceWithoutPromo.html(totalPrice);
      $priceWithPromo.html(totalPrice - (totalPrice * 66/100));
      $familyPriceContainer.html(familyPrice);
      $familyCountContainer.html(familyCount);
    }

    if (option === 'removeFamily') {
      familyPrice = price;
      totalPrice = packagePrice + donationPrice + familyPrice;
      familyCount = familyPrice / 12;

      $priceWithoutPromo.html(totalPrice);
      $priceWithPromo.html(totalPrice - (totalPrice * 66/100));
      $familyPriceContainer.html(familyPrice);
      $familyCountContainer.html(familyCount);
    }
  };

  init();

  return {
    init: init,
    updateTotalPrice: updateTotalPrice
  };

};
