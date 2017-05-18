var ToggleCheque = function () {

  'use strict';

  var $payRateRadios    = $('.option-input.monthly, .option-input.once, .recurring-input.monthly, .recurring-input.once');
  var $payMonthly       = $('.option-input.monthly');
  var $payMonthlyDon    = $('.recurring-input.monthly');
  var $chequeDiv        = $('.payment__option.cheque');

  var init = function () {
    _initEvents();
  };

  var _initEvents = function () {
    $payRateRadios.on('change', _toggleCheque);
  };

  var _toggleCheque = function () {

    if ($payMonthly.is(':checked') || $payMonthlyDon.is(':checked')) {
      $chequeDiv.css('pointer-events', 'none');
    }

    else {
      $chequeDiv.css('pointer-events', 'initial');
    }
  }

  init();

  return {
    init: init
  };
};