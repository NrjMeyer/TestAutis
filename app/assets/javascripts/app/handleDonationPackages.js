var DonationPackages = function () {

  'use strict';

  var $listItems = $('.list__item');
  var $donItems  = $('.donation__items .donation__item');

  var init = function () {
    $(window).on('resize', throttle(_toggleDonationBlocks, 400));
    $listItems.on('click', _handlePackagesSwitch);
  };

  var _toggleDonationBlocks = function () {
    var activeBlock = $('.donation__item.active');
    if ($(window).width() > 758) {
      $donItems.show();
    } else {
      $donItems.hide();
      activeBlock.show();
    }
  };

  var _handlePackagesSwitch = function (e) {
    var target = $(e.target);
    var index  = target.index();
    
    $listItems.removeClass('active');
    target.addClass('active');

    $donItems.hide().removeClass('active');
    $donItems.eq(index).show().addClass('active');
  };

  init();

  return {
    init: init
  };
}