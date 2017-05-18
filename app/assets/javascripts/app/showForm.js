var ShowForm = function (app) {

  'use strict';

  var $mainForm = $('.main-form');
  var $accountForm = $('.account-form');
  var $inputs      = $('.create-input');
  var $infoInputs  = $('.info-input');

  var init = function () {
    _initEvents();
    _validateForm();
  };

  var _initEvents = function () {
    $inputs.on('change', _handleNextStep);
  };

  var _handleNextStep = function (e) {
    var target = $(e.target);

    if (target.hasClass('create')) {
      $accountForm.show().addClass('active');
      $mainForm.parsley().destroy();
      $infoInputs.attr('data-parsley-required', 'true');
      $mainForm.parsley({
        excluded: '.input-mobile'
      });
    } else {
      $accountForm.hide().removeClass('active');
      $mainForm.parsley().destroy();
      $infoInputs.attr('data-parsley-required', 'false');
      $mainForm.parsley({
        excluded: '.input-mobile'
      });

      if ($('.payment').hasClass('hidden')) {
        app.displaySection(2);
      }
    }
  }

  var _validateForm = function () {
    $infoInputs.on('change input', throttle(function () {
      var empty = $infoInputs.filter(function () {
        return this.value === '' || this.value === false;
      });

      if (empty.length === 0 && $('.payment').hasClass('hidden')) {
        if ($('.main-form').parsley().validate({group: 'block-3'})) {
          console.log('lol');
          app.displaySection(2);
          $(window).on('scroll', throttle(app.removeFixedElement, 250));
        }
      }
    }, 500));
  };

  init();

  return {
    init: init
  };
};