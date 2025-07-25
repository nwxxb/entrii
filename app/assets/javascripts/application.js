//= require jquery3
//= require jquery_ujs
//
$(document).on('change', '.dropimage', function(e) {
	var inputfile = this;
	var reader = new FileReader();

	reader.onloadend = function() {
		$(inputfile).css('background-image', 'url(' + reader.result + ')');
	}

	reader.readAsDataURL(e.target.files[0]);
});

$(document).on('click', '[data-behaviour="add-question-form"]', function(e) {
	e.preventDefault();

	var $questionFormTemplate = $(this).siblings('template[data-target="question-form-template"]');
	var $questionsWrapper = $(this).siblings('section[data-target="questions-wrapper"]');

	var $questionForm = $($questionFormTemplate.html());
	var newId = new Date().getTime();

	$questionForm.find('fieldset').each(function() {
		$(this).find('input, select, textarea, label').each(function() {
			if($(this).attr('name')) {
				$(this).attr('name', $(this).attr('name').replace(/CHILDIDTEMPLATE/g, newId));
			}

			if($(this).attr('id')) {
				$(this).attr('id', $(this).attr('id').replace(/CHILDIDTEMPLATE/g, newId));
			}

			if($(this).attr('for')) {
				$(this).attr('for', $(this).attr('for').replace(/CHILDIDTEMPLATE/g, newId));
			}
		});
	});

	$questionForm.clone().appendTo($questionsWrapper);

	$questionsWrapper.on('click', '[data-behaviour="remove-question-form"]', function(e) {
		e.preventDefault();

		$(this).closest('.card').remove()
	});
});
