(function ( $ ) {
	var template = "<div class='multiprogress'><div class='progress-background'></div><div class='progress'></div></div>";

	$.fn.multiprogress = function( options ) {
		this.replaceWith(template);
	};

}( jQuery ));