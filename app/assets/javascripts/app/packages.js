var Packages = function () {

  'use strict';

  var chooseButtons = $('.btn__choose');
  var perksButtons  = $('.btn__perks');
  var hideButtons   = $('.btn__hide');
  var perks         = $('.choice__features');

  var init = function () {

    _initEvents();

  };

  var _initEvents = function () {

    chooseButtons.on('click', $.proxy(_selectPackage, this));

    if ($(window).width() < 768) {
      perksButtons.on('click', _showPerks);
      hideButtons.on('click', _hidePerks);
    }

  };

  var _showPerks = function (e) {
    var target = $(e.target),
        targetIndex = target.data('perks');

    perks.eq(targetIndex - 1).slideDown();

  };

  var _hidePerks = function (e) {
    var target = $(e.target),
        targetIndex = target.data('perks');

    perks.eq(targetIndex - 1).slideUp();
  };

  var _selectPackage = function (e) {

    var target = $(e.target),
        old    = $('.btn__choose--selected');

    if (target.hasClass('btn__choose--selected')) return;

    chooseButtons.removeClass('btn__choose--selected');

    target.addClass('btn__choose--selected');
    target.text('formule sélectionnée');
    old.text('choisir cette formule');

  };

  init();

  return {
    init: init
  };
}
