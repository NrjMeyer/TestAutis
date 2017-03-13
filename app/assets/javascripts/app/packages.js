var Packages = function () {

  'use strict';

  var $chooseButtons = $('.btn__choose');
  var $perksButtons  = $('.btn__perks');
  var $perks         = $('.choice__features');

  var init = function () {

    _initEvents();

  };

  var _initEvents = function () {

    $chooseButtons.on('click', $.proxy(_selectPackage, this));

    if ($(window).width() < 768) {
      $perksButtons.on('click', _togglePerks);
    }

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

    var target = $(e.target),
        old    = $('.btn__choose--selected');

    if (target.hasClass('btn__choose--selected')) return;

    $chooseButtons.removeClass('btn__choose--selected');

    target.addClass('btn__choose--selected');
    target.text('formule sélectionnée');
    old.text('choisir cette formule');

  };

  init();

  return {
    init: init
  };
}
