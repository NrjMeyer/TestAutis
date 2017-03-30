var HideMonthly = function (app) {

    'use strict';

    var $packageLabels       = $('.btn__choose');
    var $monthlyOption       = $('.monthly-offer');
    var $onceOption          = $('.option-input.once');
    var $informationsSection = $('.informations');

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
            setTimeout(function () {
                $informationsSection.addClass('visible fadeInUp');
                $('.sidebar__item').eq(2).removeClass('sidebar__item--disabled');
                app.sections.push($informationsSection);
            }, 1750);
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