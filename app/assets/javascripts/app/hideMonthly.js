var HideMonthly = function () {

    'use strict';

    var $packageLabels = $('.btn__choose');
    var $monthlyOption = $('.monthly-offer');
    var $onceOption    = $('.option-input.once');

    var init = function () {
        _initEvents();
    };

    var _initEvents = function () {

        $packageLabels.on('click', _disableMonthly);

    };

    var _disableMonthly = function () {
        if ($(this).hasClass('no-monthly-offer')) {
            $monthlyOption.hide();
            $onceOption.prop('checked', true);
        }

        else {
            $monthlyOption.show();
        }
    }

    init();

    return {
        init: init
    };

};