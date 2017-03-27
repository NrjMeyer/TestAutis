var FamilyMember = function (app) {

  'use strict';

  var $deleteButton     = $('.member__delete');
  var $addButton        = $('.js-add-member');
  var $membersContainer = $('.members ul');
  var $nameInput        = $('#family-name');
  var $mailInput        = $('#family-mail');

  // Keep track of the total price of subscriptions for family members
  var familyTotal       = 0;

  var init = function () {

    _initEvents();

  }

  var _initEvents = function () {

    $addButton.on('click', _addRow);

  }

  var _deleteRow = function () {

    $(this).parent().remove();

    familyTotal -= 12;

    app.updateTotalPrice('removeFamily', familyTotal);
  }

  var _addRow = function () {

    var name           = $nameInput.val(),
        mail           = $mailInput.val(),
        $membersLength = $('.member').length;

    if ($('.main-form').parsley().validate({group: 'family-member', force: true}) && $membersLength === 0 && $('.member__title').length === 0) {
      $membersContainer.append('<p class="member__title">Membre(s) ajouté(s) :</p>');
    }

    if ($('.main-form').parsley().validate({group: 'family-member', force: true}) && $membersLength < 5 && !_isAlreadyAdded(mail)) {

      $membersContainer.append('<li class="member">\
          <p class="member__name">'+name+'</p>\
          <p class="member__mail">'+mail+'</p>\
          <div class="member__delete">\
            <svg width="18" height="17" viewBox="0 0 18 17" xmlns="http://www.w3.org/2000/svg" class="icon-delete">\
              <g fill="#CFCFCF" fill-rule="evenodd">\
                <path d="M8.995 0C4.298 0 .5 3.798.5 8.495c0 4.697 3.798 8.495 8.495 8.495 4.697 0 8.495-3.798 8.495-8.495C17.49 3.798 13.692 0 8.995 0zm0 15.99c-4.098 0-7.496-3.398-7.496-7.495C1.5 4.397 4.896 1 8.994 1c4.097 0 7.495 3.397 7.495 7.495 0 4.097-3.398 7.495-7.495 7.495z"></path>\
                <path d="M11.393 6.096c-.2-.2-.5-.2-.7 0l-1.748 1.75-1.75-1.75c-.2-.2-.5-.2-.7 0-.2.2-.2.5 0 .7l1.75 1.75-1.75 1.748c-.2.2-.2.5 0 .7.1.1.3.1.4.1.1 0 .3-.1.3-.1l1.75-1.75 1.75 1.75c.1.1.3.1.398.1.1 0 .2-.1.3-.1.2-.2.2-.5 0-.7l-1.75-1.75 1.75-1.748c.2-.2.2-.5 0-.7z"></path>\
              </g>\
            </svg>\
            <span>Supprimer</span>\
          </div>\
        </li>');

        $nameInput.val('');
        $mailInput.val('');

        $deleteButton = $('.member__delete');

        $deleteButton.unbind('click');

        $deleteButton.on('click', _deleteRow);

        familyTotal += 12;

        app.updateTotalPrice('addFamily', familyTotal);
    }
  };

  var _isAlreadyAdded = function (value) {

    var added;
    var $familyMail = $('.member__mail');

    $familyMail.each(function () {
      if ($(this).text() === value) {
        added = true;
      }

      else {
        added = false;
      }
    });

    return added;

  };

  init();

  return {
    init: init
  };

}
