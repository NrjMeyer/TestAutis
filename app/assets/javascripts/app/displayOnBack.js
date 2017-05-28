var DisplayOnBack = function (app, isSubscription) {

  'use strict';

  var $packageOption = $("input[name='formule']:checked");
  var $paymentMethod = $("input[name='payment_option']:checked");
  var $donationInput = $('.input__donation');
  var $sections      = $('.js-section');

  var init = function () {
    _checkIfFilled();
  };

  var _checkIfFilled = function () {
    if ($paymentMethod.length > 0) {
      $paymentMethod.prop('checked', false);
      $sections.removeClass('js-hidden hidden');
      _handlePackageOption();

      if (isSubscription) {
        _handleDonation();
      }
    }
  };

  var _handlePackageOption = function () {
    var id    = $packageOption.attr('value');
    var label = $("label[for='formule_"+id+"']")//$packageOption.next('.btn__choose');
    var price = label.data('price');

    label.addClass('btn__choose--selected');
    isSubscription 
      ? label.html('formule sélectionnée') 
      : label.html('sélectionné');
    app.updateTotalPrice('package', price);
  };

  var _handleDonation = function () {
    if ($donationInput.val()) {
      var value = $donationInput.val();
      var price = parseInt(value);


      app.updateTotalPrice('donation', price);
    }
  };

  init();

  return {
    init: init
  };
}