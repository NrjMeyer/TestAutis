var Payment = function () {

  'use strict';

  var $paymentOptions        = $('.payment__option');
  var $paymentSections       = $('.payment__section');
  var $paymentSectionsMobile = $('.payment__section--mobile');
  var $paymentInfo           = $('.js-payment__info');

  var init = function () {

    _initEvents();

  };

  var _initEvents = function () {

    if ($(window).width() > 767) {
      $paymentOptions.on('click', _changePaymentMethod);
    }

    if ($(window).width() < 768) {
      $paymentOptions.on('click', _changePaymentMethodMobile);
    }

  }

  var _changePaymentMethod = function (e) {

    var target = $(e.target),
        targetOption;

    if (target.hasClass('label')) {
      target = target.parent();
    }

    if (!$paymentOptions.hasClass('payment__option--selected')) {
      $paymentInfo.addClass('hidden');
    }

    $paymentOptions.removeClass('payment__option--selected');

    if (target.hasClass('payment__option')) {
      targetOption = target.data('option');
      $(this).addClass('payment__option--selected');
    }

    $paymentSections.hide();
    $('.payment__section[data-option='+targetOption+']').show();

    $('input#' + targetOption).prop('checked', true);

  };

  var _changePaymentMethodMobile = function (e) {

    var target = $(e.target),
        targetOption;

    if (target.hasClass('label')) {
      target = target.parent();
    }

    if (!$paymentOptions.hasClass('payment__option--selected')) {
      $paymentInfo.addClass('hidden');
    }

    $paymentOptions.removeClass('payment__option--selected');

    if (target.hasClass('payment__option')) {
      targetOption = target.data('option');
      $(this).addClass('payment__option--selected');
    }

    $paymentSectionsMobile.hide();
    $('.payment__section--mobile[data-option='+targetOption+']').show();

  };

  init();

  return {
    init: init
  };

};