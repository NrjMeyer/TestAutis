var Donation = function () {

  'use strict';
  var $donateRate = $('input[name="donate-rate"]');

  var init = function () {
    _initEvents();
  };

  var _initEvents = function () {
    $donateRate.on('change', _bindDonateChange);
  };

  var _bindDonateChange = function () {
    var val = $('input[name="donate-rate"]:checked').val();
    $('input[name="monthly"][value="'+val+'"]').prop('checked',true);
  };

  init();

  return {
    init: init
  };

};
