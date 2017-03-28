var Form = function () {

  'use strict';

  var $form = $('.main-form');

  var init = function () {
    _initFormValidation();
  };

  var _initFormValidation = function () {
    $form.parsley({
      excluded: '.input-mobile'
    });
  }

  init();

  return {
    init: init
  };

};
