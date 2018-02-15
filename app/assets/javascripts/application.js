// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require blueimp-gallery-all
//= require filterrific/filterrific-jquery
//= require cocoon

$(function() {
	//Fix the hidden element issue on some chrome browsers
  	window.scroll(0,1);
  	window.scroll(0,0);

	$('.donate-now-button').click(function(){
		$('.donate-now-button').prop('disabled', true);
		$('.donate-now-button').css('cursor', 'wait');
		$('#donateModal').css('cursor', 'wait');
		$('#donateForm').submit();
	});

	$('.create-new-dream').click(function(){
		$('.create-new-dream').prop('disabled', true);
		$('.create-new-dream').css('cursor', 'wait');
		$('#createDreamForm').submit();
		$('.loading-new-dream').fadeIn();
		setInterval(function(){
			$('.loading-new-dream').fadeOut('fast', function() {
				$(this).text("It usually takes 8 seconds. Take a deep breath while we're making the Playa for you. Creating a folder in the cloud and syncing...").fadeIn('fast');
			})}, 4000);
	});
});
