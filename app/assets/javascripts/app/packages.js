var Packages = function (app, isSubscription) {

  'use strict';

  var $chooseButtons = $('.btn__choose');
  var $perksButtons  = $('.btn__perks');
  var $perks         = $('.choice__features');
  var $donationInput = $('.donation-input');
  var $donationRadio = $('.donation-radio');
  var $donationLabel = $('.btn__choose--free');
  var $freeDonInput  = $('.custom-donation-input');
  var $promoDonation = $('.free-input');

  var init = function () {

    _initEvents();

  };

  var _initEvents = function () {

    $chooseButtons.on('click', $.proxy(_selectPackage, this));
    $donationInput.on('keyup input', throttle(_handleDonationInput, 250));

    if ($(window).width() < 768) {
      $perksButtons.on('click', _togglePerks);
    }

  };

  var _handleDonationInput = function () {
    var inputValue = $donationInput.val();

    if (inputValue.length > 0 && inputValue > 0) {
      $donationLabel.css('pointer-events', 'initial').removeClass('disabled');
    } else {
      $donationRadio.attr('checked', false);
      $donationLabel.css('pointer-events', 'none').addClass('disabled').removeClass('btn__choose--selected');
      $donationLabel.html('choisir');
    }

    $donationLabel.attr('data-price', inputValue);
    $freeDonInput.attr('value', '-' + inputValue);
    $promoDonation.html(app.toFixed(inputValue * (66 / 100), 2) + '€');
  };

  var _togglePerks = function (e) {
    var target = $(e.target),
        targetIndex = target.data('perks');

    if (target.hasClass('active')) {
      target.html('voir les avantages')
    }

    else {
      target.html('masquer les avantages');
    }
    target.toggleClass('active');
    $perks.eq(targetIndex - 1).slideToggle();

  };

  var _selectPackage = function (e) {

    var target      = $(e.target),
        targetPrice = target.data('price'),
        old         = $('.btn__choose--selected');

    if (target.hasClass('btn__choose--selected')) return;

    $chooseButtons.removeClass('btn__choose--selected');

    target.addClass('btn__choose--selected');

    if (isSubscription) {
      target.text('formule sélectionnée');
      old.text('choisir cette formule');
    } else {
      target.text('sélectionné');
      old.text('choisir');
    }
    
    app.updateTotalPrice('package', targetPrice);
    

  };

  init();

  return {
    init: init
  };
}
