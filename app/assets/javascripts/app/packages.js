var Packages = function () {

  'use strict';

  var chooseButtons        = $('.btn__choose');

  var init = function () {

    _initEvents();

  };

  var _initEvents = function () {

    chooseButtons.on('click', $.proxy(_selectPackage, this));

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
