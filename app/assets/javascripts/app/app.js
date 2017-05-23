var App = function (isSubscription) {

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
    offsetInfos   = $infosSection.offset().top;
    offsetPayment = $paymentSection.offset().top;

    if (isSubscription) {
      offsetOptions = $optionsSection.offset().top;
    }
  }

  var offsets;
  if (isSubscription) {
    offsets = [offsetChoice, offsetOptions, offsetInfos, offsetPayment];
  } else {
    offsets = [offsetChoice, offsetInfos, offsetPayment];
  }

  // Display sections variables
  var $firstSectionInputs;
  if (isSubscription) {
    $firstSectionInputs  = $('.formule-input');
  } else {
    $firstSectionInputs  = $('.formule-input, .recurring-input');
  }
  var $secondSectionInputs = $('.option-input');
  var $thirdSectionInputs  = $('.info-input');

  // Paying monthly input
  var $optionsInput = $('.option-input, .recurring-input');
  var monthlyPayment = false;
  var $monthlySpans  = $('.monthly-payment');

  // Monthly donation
  var $donationsOptions = $('.donation-options');
  var $donationInput    = $('.input__donation');
  var $donationSpan     = $('.monthly-donation');

  // Scroll variables
  var sections = [];

  // Update price variables
  var packagePrice  = 0;
  var familyPrice   = 0;
  var familyCount   = 0;
  var donationPrice = 0;
  var totalPrice    = packagePrice + familyPrice + donationPrice;

  // Price sections
  var $priceWithoutPromo    = $('.total-price--withoutPromo');
  var $priceWithPromo       = $('.total-price--withPromo');
  var $subscriptionPrice    = $('.adhesion-price');
  var $familyPriceContainer = $('.family-price');
  var $familyCountContainer = $('.family-count');
  var $donationPrice        = $('.donation-price');

  var init = function () {

    _initEvents();
    _fixedElement();
    _initSelects();

    if (isSubscription) {
      _checkThirdSection();
    }

    if ($(window).width() > 1149) {
      _highlightSection();
    }

    // hide sections
    //$('.js-hidden').addClass('hidden');

  };

  var _initEvents = function () {

    if ($(window).width() < 1024) {
      $burgerMenu.on('click', _toggleMenu);
    }

    $(window).on('resize', _fixedElement);

    $sidebarItems.on('click', _goToSection);
    if (isSubscription) {
      $firstSectionInputs.on('change', function(){displaySection(1)});
    } else {
      $firstSectionInputs.on('change', _checkFirstSection);
    }

    $secondSectionInputs.on('change', function(){displaySection(2)});

    $optionsInput.on('change', _showMonthlyPrice);
    $donationsOptions.on('change', _showMonthlyPrice);
    $donationInput.on('input', throttle(_updateDonationPrice, 250));

  };

  var _showMonthlyPrice = function () {

    if ($(this).hasClass('once')) {
      if (isSubscription) {
        $monthlySpans.removeClass('active');
      } else {
        $monthlySpans.removeClass('active');
        $donationSpan.removeClass('active');
      }
      monthlyPayment = false;
    }

    else if ($(this).hasClass('monthly')) {
      if (isSubscription) {
        $monthlySpans.addClass('active');
      } else {
        $monthlySpans.addClass('active');
        $donationSpan.addClass('active');
      }

      monthlyPayment = true;
    }

    else if ($(this).hasClass('donation-monthly')) {
      if (!$monthlySpans.hasClass('active')) {
        $monthlySpans.addClass('active');
      };
      $donationSpan.addClass('active');
      monthlyPayment = true;
    }

    else if ($(this).hasClass('donation-once')) {
      if ($monthlySpans.hasClass('active')) {
        $monthlySpans.removeClass('active');
      };
      $donationSpan.removeClass('active');
      monthlyPayment = false;
    }

    updateTotalPrice();

  };

  var _updateDonationPrice = function () {

    var donation = $(this).val();
    donation = parseInt(donation);

    updateTotalPrice('donation', donation)
  };

  var _fixedElement = function () {

    var sectionWidth = $('.payment').outerWidth();

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

  var _checkFirstSection = function () {
    if ($("input[name='monthly']:checked").val() && $("input[name='formule']:checked").val()) {
      displaySection(1);
    }
  }
  var _checkThirdSection = function () {

    $thirdSectionInputs.on('change input', throttle(function () {
      var empty = $thirdSectionInputs.filter(function () {
        return this.value === "" || this.value === false;
      });

      if (empty.length === 0 && $paymentSection.hasClass('hidden')) {
        if ($('.main-form').parsley().validate({group: 'block-3'})) {
          displaySection(3);
          $(window).on('scroll', throttle(removeFixedElement, 250));
        }
      }
    }, 500));

  };

  var removeFixedElement = function () {
    if ($fixedBar.offset().top > $('.js-sticky').offset().top) {
      $fixedBar.hide();
    }
  };

  var displaySection = function (number) {

    var current = $allSections[number];

    if ($(current).hasClass('visible')) return;

    // add section to scroll spy function
    sections.push($(current));

    $(current).removeClass('hidden').addClass('visible');

    if ($(window).width() > 767) {
      $(current).addClass('fadeInUp');
    }

    if (isSubscription) {
      if (!$(current).hasClass('informations')) {
        $('html, body').animate({
          scrollTop: $(current).offset().top
        }, 1500);
      }
    } else {
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
    }

    if (option === 'donation') {
      donationPrice = price;
      totalPrice = packagePrice + donationPrice + familyPrice;
    }

    if (option === 'addFamily') {
      familyPrice = price;
      totalPrice = packagePrice + donationPrice + familyPrice;
      familyCount = familyPrice / 12;
    }

    if (option === 'removeFamily') {
      familyPrice = price;
      totalPrice = packagePrice + donationPrice + familyPrice;
      familyCount = familyPrice / 12;
    }

    if (isSubscription) {
      if (monthlyPayment) {
        // update all prices monthly
        $subscriptionPrice.eq(0).html(packagePrice);
        $subscriptionPrice.eq(1).html(toFixed(packagePrice / 12, 2));
        $priceWithoutPromo.html(toFixed(totalPrice / 12, 2));
        $priceWithPromo.html(toFixed(((totalPrice - (totalPrice * 66/100)) / 12), 2));
        $familyPriceContainer.html(toFixed(familyPrice / 12, 2));
        $familyCountContainer.html(familyCount);
        $donationPrice.html(donationPrice);
      }

      else {
        // update all prices
        $subscriptionPrice.html(packagePrice);
        $priceWithoutPromo.html(totalPrice);
        $priceWithPromo.html(toFixed(totalPrice - (totalPrice * 66/100), 2));
        $familyPriceContainer.html(familyPrice);
        $familyCountContainer.html(familyCount);
        $donationPrice.html(donationPrice);
      }
    } else {
        // update all prices
        $priceWithoutPromo.html(totalPrice);
        $priceWithPromo.html(toFixed(totalPrice - (totalPrice * 66/100), 2));
        $donationPrice.html(packagePrice);
    }




  };

  // Helper function to splice decimals after 2
  var toFixed = function (num, fixed) {
    var re = new RegExp('^-?\\d+(?:\.\\d{0,' + (fixed || -1) + '})?');
    return num.toString().match(re)[0];
  };

  init();

  return {
    init: init,
    displaySection: displaySection,
    removeFixedElement: removeFixedElement,
    updateTotalPrice: updateTotalPrice,
    sections: sections,
    toFixed: toFixed
  };

};
