var ShowForm = function (app) {

  'use strict';

  var $mainForm = $('.main-form');
  var $accountForm = $('.account-form');
  var $infoInputs  = $('.info-input');

  var init = function () {
    _initEvents();
  };

  var _initEvents = function () {
    $infoInputs.on('change input', throttle(_showNextSection, 500));
  };

  var _showNextSection = function () {
    var empty = $infoInputs.filter(function () {
      return this.value === '' || this.value === false;
    });

    if (empty.length === 0 && $('.payment').hasClass('hidden')) {
      if ($('.main-form').parsley().validate({group: 'block-3'})) {
        app.displaySection(2);
        $(window).on('scroll', throttle(app.removeFixedElement, 250));
      }
    }
  };

  init();

  return {
    init: init
  };
};
