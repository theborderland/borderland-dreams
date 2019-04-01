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
//= require best_in_place
//= require best_in_place.jquery-ui
//= require jquery.purr
//= require best_in_place.purr
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
				$(this).text("זה לרוב לוקח כ-8 שניות. קח נשימה עמוקה בזמן שאנחנו מכינים את הפלאייה עבורך. יוצרים לך תיקייה בדרייב ומסנכרנים...").fadeIn('fast'); 
			})}, 4000);
	});

	$(document).ready(function() {
    $('[id^="favorite-button"]').click(function (e) {
				var button = $(event.target).parent();
        if(e.target.classList.contains("glyphicon-star")) {
					button.removeClass('starred')
					button.find("#star-icon").removeClass('glyphicon-star')
					button.find("#star-icon").addClass("glyphicon-star-empty")
        } else {
					button.addClass('starred')
					button.find("#star-icon").removeClass("glyphicon-star-empty")
          button.find("#star-icon").addClass('glyphicon-star')
        }
		});
		
		$(function() {
			$("#toggle").click(function() {
				if ($(this).is(":checked")) {
					$("#grid-view").hide();
					$("#table-view").show();
				} else {

					$("#grid-view").show();
					$("#table-view").hide();
				}
			});
		});

		function getUrl(el) {
			return $(el).closest('a').attr('href');
		}

		function postColor(e, color) {
			var url = getUrl(e.target);
			console.log(e);
			var color = $(".basic").val();
			var token = getAuthenticityToken(e.target);
	
			e.preventDefault();
	
			$.ajax({
				url: url,
				type: 'POST',
				data: {method:'_patch', 'camp[color]': color, authenticity_token:token},
				success: function(data) {
					e.target.css('background-color', color)
				}
			});
	
			return false;
		}
		var elements = $('[id^="edit_camp"]');

		$('.change_color').css('visibility', 'hidden');

		elements.each(function (index) {
		  var basic = $(elements[index]).find('.basic');
		  var things = $(elements[index]).attr('id').split('_');
		  var the_id = things[things.length - 1];
		  basic.spectrum({
		    // color: "#f00",
		    change: function change(color) {
		      var rgb = color.toRgb();
		      var rgb_string = 'rgb(' + rgb['r'] + ',' + rgb['g'] + ',' + rgb['b'] + ')'; // basic.find("#basic-log").text("change called: " + color.toHexString());

		      basic.val(rgb_string);
		      $('.panel-info' + the_id).css('background-color', rgb_string);
		      elements[index].submit();
		    }
		  });
		});
});
});