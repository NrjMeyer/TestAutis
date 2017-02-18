(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
window.app = require('./partials/app.js');

$(document).ready(function() {
  app.init();
});

},{"./partials/app.js":2}],2:[function(require,module,exports){
module.exports = (function () {

  'use strict';

  var chooseButtons        = $('.btn__choose');

  var paymentOptions       = $('.payment__option');
  var paymentSections      = $('.payment__section');

  var subscriberTypeSelect = $('#subscriber-type');

  var sidebarItems         = $('.sidebar__item');

  var offsetChoice          = $('.choice').offset().top;
  var offsetOptions         = $('.options').offset().top;
  var offsetInfos           = $('.informations').offset().top;
  var offsetPayment         = $('.payment').offset().top;

  var offsets = [offsetChoice, offsetOptions, offsetInfos, offsetPayment];

  var init = function () {

    _initEvents();
    _initSelects();

  };

  var _initEvents = function () {

    chooseButtons.on('click', $.proxy(_selectPackage, this));
    paymentOptions.on('click', $.proxy(_changePaymentMethod, this));
    sidebarItems.on('click', $.proxy(_goToSection, this));

    // $(window).on('scroll', $.proxy(_checkCurrentSection, this));

  };

  var _goToSection = function (e) {
    var target = $(e.target),
        targetIndex = target.index();

    if (targetIndex === 4) return;

    $('html, body').animate({
      scrollTop: offsets[targetIndex] - 25
    }, 500);


  };

  var _selectPackage = function (e) {
    var target = $(e.target),
        old    = $('.btn__choose--selected');

    chooseButtons.removeClass('btn__choose--selected');

    target.addClass('btn__choose--selected');
    target.text('formule sélectionnée');
    old.text('choisir cette formule');
  };

  var _changePaymentMethod = function (e) {
    var target = $(e.target),
        targetIndex = target.index() / 2;

    paymentOptions.removeClass('payment__option--selected');

     if (target.hasClass('payment__option')) {
        $(this).addClass('payment__option--selected');
     }

     paymentSections.hide();
     paymentSections.eq(targetIndex).show();

  };

  var _initSelects = function () {

    subscriberTypeSelect.dropkick({mobile:true});

  };

  return {
    init: init
  };

})();

},{}]},{},[1])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCJhcHAvYXNzZXRzL3NjcmlwdHMvbWFpbi5qcyIsImFwcC9hc3NldHMvc2NyaXB0cy9wYXJ0aWFscy9hcHAuanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7QUNBQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FDTEE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0EiLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXNDb250ZW50IjpbIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dmFyIGY9bmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKTt0aHJvdyBmLmNvZGU9XCJNT0RVTEVfTk9UX0ZPVU5EXCIsZn12YXIgbD1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwobC5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxsLGwuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIiwid2luZG93LmFwcCA9IHJlcXVpcmUoJy4vcGFydGlhbHMvYXBwLmpzJyk7XHJcblxyXG4kKGRvY3VtZW50KS5yZWFkeShmdW5jdGlvbigpIHtcclxuICBhcHAuaW5pdCgpO1xyXG59KTtcclxuIiwibW9kdWxlLmV4cG9ydHMgPSAoZnVuY3Rpb24gKCkge1xyXG5cclxuICAndXNlIHN0cmljdCc7XHJcblxyXG4gIHZhciBjaG9vc2VCdXR0b25zICAgICAgICA9ICQoJy5idG5fX2Nob29zZScpO1xyXG5cclxuICB2YXIgcGF5bWVudE9wdGlvbnMgICAgICAgPSAkKCcucGF5bWVudF9fb3B0aW9uJyk7XHJcbiAgdmFyIHBheW1lbnRTZWN0aW9ucyAgICAgID0gJCgnLnBheW1lbnRfX3NlY3Rpb24nKTtcclxuXHJcbiAgdmFyIHN1YnNjcmliZXJUeXBlU2VsZWN0ID0gJCgnI3N1YnNjcmliZXItdHlwZScpO1xyXG5cclxuICB2YXIgc2lkZWJhckl0ZW1zICAgICAgICAgPSAkKCcuc2lkZWJhcl9faXRlbScpO1xyXG5cclxuICB2YXIgb2Zmc2V0Q2hvaWNlICAgICAgICAgID0gJCgnLmNob2ljZScpLm9mZnNldCgpLnRvcDtcclxuICB2YXIgb2Zmc2V0T3B0aW9ucyAgICAgICAgID0gJCgnLm9wdGlvbnMnKS5vZmZzZXQoKS50b3A7XHJcbiAgdmFyIG9mZnNldEluZm9zICAgICAgICAgICA9ICQoJy5pbmZvcm1hdGlvbnMnKS5vZmZzZXQoKS50b3A7XHJcbiAgdmFyIG9mZnNldFBheW1lbnQgICAgICAgICA9ICQoJy5wYXltZW50Jykub2Zmc2V0KCkudG9wO1xyXG5cclxuICB2YXIgb2Zmc2V0cyA9IFtvZmZzZXRDaG9pY2UsIG9mZnNldE9wdGlvbnMsIG9mZnNldEluZm9zLCBvZmZzZXRQYXltZW50XTtcclxuXHJcbiAgdmFyIGluaXQgPSBmdW5jdGlvbiAoKSB7XHJcblxyXG4gICAgX2luaXRFdmVudHMoKTtcclxuICAgIF9pbml0U2VsZWN0cygpO1xyXG5cclxuICB9O1xyXG5cclxuICB2YXIgX2luaXRFdmVudHMgPSBmdW5jdGlvbiAoKSB7XHJcblxyXG4gICAgY2hvb3NlQnV0dG9ucy5vbignY2xpY2snLCAkLnByb3h5KF9zZWxlY3RQYWNrYWdlLCB0aGlzKSk7XHJcbiAgICBwYXltZW50T3B0aW9ucy5vbignY2xpY2snLCAkLnByb3h5KF9jaGFuZ2VQYXltZW50TWV0aG9kLCB0aGlzKSk7XHJcbiAgICBzaWRlYmFySXRlbXMub24oJ2NsaWNrJywgJC5wcm94eShfZ29Ub1NlY3Rpb24sIHRoaXMpKTtcclxuXHJcbiAgICAvLyAkKHdpbmRvdykub24oJ3Njcm9sbCcsICQucHJveHkoX2NoZWNrQ3VycmVudFNlY3Rpb24sIHRoaXMpKTtcclxuXHJcbiAgfTtcclxuXHJcbiAgdmFyIF9nb1RvU2VjdGlvbiA9IGZ1bmN0aW9uIChlKSB7XHJcbiAgICB2YXIgdGFyZ2V0ID0gJChlLnRhcmdldCksXHJcbiAgICAgICAgdGFyZ2V0SW5kZXggPSB0YXJnZXQuaW5kZXgoKTtcclxuXHJcbiAgICBpZiAodGFyZ2V0SW5kZXggPT09IDQpIHJldHVybjtcclxuXHJcbiAgICAkKCdodG1sLCBib2R5JykuYW5pbWF0ZSh7XHJcbiAgICAgIHNjcm9sbFRvcDogb2Zmc2V0c1t0YXJnZXRJbmRleF0gLSAyNVxyXG4gICAgfSwgNTAwKTtcclxuXHJcblxyXG4gIH07XHJcblxyXG4gIHZhciBfc2VsZWN0UGFja2FnZSA9IGZ1bmN0aW9uIChlKSB7XHJcbiAgICB2YXIgdGFyZ2V0ID0gJChlLnRhcmdldCksXHJcbiAgICAgICAgb2xkICAgID0gJCgnLmJ0bl9fY2hvb3NlLS1zZWxlY3RlZCcpO1xyXG5cclxuICAgIGNob29zZUJ1dHRvbnMucmVtb3ZlQ2xhc3MoJ2J0bl9fY2hvb3NlLS1zZWxlY3RlZCcpO1xyXG5cclxuICAgIHRhcmdldC5hZGRDbGFzcygnYnRuX19jaG9vc2UtLXNlbGVjdGVkJyk7XHJcbiAgICB0YXJnZXQudGV4dCgnZm9ybXVsZSBzw6lsZWN0aW9ubsOpZScpO1xyXG4gICAgb2xkLnRleHQoJ2Nob2lzaXIgY2V0dGUgZm9ybXVsZScpO1xyXG4gIH07XHJcblxyXG4gIHZhciBfY2hhbmdlUGF5bWVudE1ldGhvZCA9IGZ1bmN0aW9uIChlKSB7XHJcbiAgICB2YXIgdGFyZ2V0ID0gJChlLnRhcmdldCksXHJcbiAgICAgICAgdGFyZ2V0SW5kZXggPSB0YXJnZXQuaW5kZXgoKSAvIDI7XHJcblxyXG4gICAgcGF5bWVudE9wdGlvbnMucmVtb3ZlQ2xhc3MoJ3BheW1lbnRfX29wdGlvbi0tc2VsZWN0ZWQnKTtcclxuXHJcbiAgICAgaWYgKHRhcmdldC5oYXNDbGFzcygncGF5bWVudF9fb3B0aW9uJykpIHtcclxuICAgICAgICAkKHRoaXMpLmFkZENsYXNzKCdwYXltZW50X19vcHRpb24tLXNlbGVjdGVkJyk7XHJcbiAgICAgfVxyXG5cclxuICAgICBwYXltZW50U2VjdGlvbnMuaGlkZSgpO1xyXG4gICAgIHBheW1lbnRTZWN0aW9ucy5lcSh0YXJnZXRJbmRleCkuc2hvdygpO1xyXG5cclxuICB9O1xyXG5cclxuICB2YXIgX2luaXRTZWxlY3RzID0gZnVuY3Rpb24gKCkge1xyXG5cclxuICAgIHN1YnNjcmliZXJUeXBlU2VsZWN0LmRyb3BraWNrKHttb2JpbGU6dHJ1ZX0pO1xyXG5cclxuICB9O1xyXG5cclxuICByZXR1cm4ge1xyXG4gICAgaW5pdDogaW5pdFxyXG4gIH07XHJcblxyXG59KSgpO1xyXG4iXX0=
