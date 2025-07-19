//= require jquery3
//= require jquery_ujs

$(document).on('change', '.dropimage', function(e) {
	var inputfile = this;
	var reader = new FileReader();

	reader.onloadend = function() {
		$(inputfile).css('background-image', 'url(' + reader.result + ')');
	}

	reader.readAsDataURL(e.target.files[0]);
});
