var Payment = function () {

  'use strict';

  var paymentOptions  = $('.payment__option');
  var paymentSections = $('.payment__section');

  var init = function () {

    _initEvents();

  };

  var _initEvents = function () {

    paymentOptions.on('click', $.proxy(_changePaymentMethod, this));

  }

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

  init();

  return {
    init: init
  };

};
