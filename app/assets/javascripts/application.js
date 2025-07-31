//= require jquery3
//= require jquery_ujs
//
$(document).on('change', '.field__dropimage', function(e) {
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

	$questionForm.find('input, select, textarea, label').each(function() {
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

	$questionForm.clone().appendTo($questionsWrapper);
	updateCardQuestionPositionValue();
});

$(document).on('click', '[data-behaviour="remove-question-form"]', function(e) {
	e.preventDefault();

	var $card = $(this).closest('.card.question-form')

	$card.children('input[name^="questionnaire[questions_attributes]"][name$="[_destroy]"]').val("1")
	$card.children('fieldset').remove()
	$card.hide()
	updateCardQuestionPositionValue();
})

$(document).on('click', '[data-behaviour="change-question-position-up"]', function(e) {
	e.preventDefault();

	var $card = $(this).closest('.card.question-form')
	$card.prev().insertAfter($card)
	updateCardQuestionPositionValue();
})

$(document).on('click', '[data-behaviour="change-question-position-down"]', function(e) {
	e.preventDefault();

	var $card = $(this).closest('.card.question-form')
	$card.next().insertBefore($card)
	updateCardQuestionPositionValue();
})

$(document).on('turbo:load', function(e) {
	updateCardQuestionPositionValue();
})

function updateCardQuestionPositionValue() {
	$questionsWrapper = $('[data-target="questions-wrapper"]')
	if($questionsWrapper.length > 0 && $questionsWrapper.children().length > 0) {
		$questionsWrapper.children('.question-form:visible').each(function(idx) {
			$card = $(this)

			$card.find('input[name^="questionnaire[questions_attributes]"][name$="[position]"]').val(String(idx))
		})
	}
}
