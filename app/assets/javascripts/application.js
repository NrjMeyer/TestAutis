// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_directory ./vendors
//= require_directory ./app

$(document).on('turbolinks:load', function () {

  var isSubscription = false;

  if ($('.main__container').hasClass('is-subscription')) {
    isSubscription = true;
  }

  var app = new App(isSubscription);
  var form = new Form();
  var payment = new Payment();
  var donation = new Donation();
  var packages = new Packages(app, isSubscription);
  var addMember = new FamilyMember(app);
  var hideMonthly = new HideMonthly(app);
  var togglePayments = new TogglePayments();
  var displayOnBack = new DisplayOnBack(app, isSubscription);

  if (!isSubscription) {
    var showForm = new ShowForm(app);
    var donationPackages = new DonationPackages();
  }

});
