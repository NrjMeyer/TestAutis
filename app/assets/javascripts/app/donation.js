var Donation = function () {

  'use strict';
  var $donateRate = $('input[name="donate-rate"]');
  var $monthly = $('input[name="monthly"]');

  var init = function () {
    _initEvents();
  };

  var _initEvents = function () {
    $donateRate.on('change', _bindDonateChange);
    $monthly.on('change', _bindDonateChangeBis);
  };

  var _bindDonateChange = function () {
    var val = $('input[name="donate-rate"]:checked').val();
    $('input[name="monthly"][value="'+val+'"]').prop('checked',true);
  };

  var _bindDonateChangeBis = function () {
    
    if ($('input[name="donate-rate"]:checked').val()){
      var val = $('input[name="monthly"]:checked').val();
      $('input[name="donate-rate"][value="'+val+'"]').prop('checked',true);
    }
  };

  init();

  return {
    init: init
  };

};
