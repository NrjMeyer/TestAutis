var App = function () {

  'use strict';

  var chooseButtons        = $('.btn__choose');

  var paymentOptions       = $('.payment__option');
  var paymentSections      = $('.payment__section');

  var subscriberTypeSelect = $('#subscriber-type');

  var sidebarItems         = $('.sidebar__item');

  var offsetChoice          = $('.choice').offset().top;
  var offsetOptions         = $('.options').offset().top;
  var offsetInfos           = $('.informations').offset().top;
  var offsetPayment         = $('.payment').offset().top;

  var offsets = [offsetChoice, offsetOptions, offsetInfos, offsetPayment];

  var init = function () {

    _initEvents();
    _initSelects();

  };

  var _initEvents = function () {

    chooseButtons.on('click', $.proxy(_selectPackage, this));
    paymentOptions.on('click', $.proxy(_changePaymentMethod, this));
    sidebarItems.on('click', $.proxy(_goToSection, this));

    // $(window).on('scroll', $.proxy(_checkCurrentSection, this));

  };

  var _goToSection = function (e) {
    var target = $(e.target),
        targetIndex = target.index();

    if (targetIndex === 4) return;

    $('html, body').animate({
      scrollTop: offsets[targetIndex] - 25
    }, 500);


  };

  var _selectPackage = function (e) {
    var target = $(e.target),
        old    = $('.btn__choose--selected');

    chooseButtons.removeClass('btn__choose--selected');

    target.addClass('btn__choose--selected');
    target.text('formule sélectionnée');
    old.text('choisir cette formule');
  };

  var _changePaymentMethod = function (e) {
    var target = $(e.target),
        targetIndex = target.index() / 2;

    paymentOptions.removeClass('payment__option--selected');

     if (target.hasClass('payment__option')) {
        $(this).addClass('payment__option--selected');
     }

     paymentSections.hide();
     paymentSections.eq(targetIndex).show();

  };

  var _initSelects = function () {

    subscriberTypeSelect.dropkick({mobile:true});

  };

  init();

  return {
    init: init
  };

};
