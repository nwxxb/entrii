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

	var $formParent = $(this).closest('form');
	var $questionFormTemplate = $formParent.children('template[data-target="question-form-template"]')
	var $questionsWrapper = $formParent.children('section[data-target="questions-wrapper"]')

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

	$clonedQuestionForm = $questionForm.clone().appendTo($questionsWrapper);
	updateCardQuestionPositionValue();
	toggleEmptyStateGhostSection()
	togglePreviewButtonEnability()

	$clonedQuestionForm.find('input:visible').first().trigger("focus");
});

$(document).on('click', '[data-behaviour="remove-question-form"]', function(e) {
	e.preventDefault();

	var $card = $(this).closest('.card.question-form')

	$card.children('input[name^="questionnaire[questions_attributes]"][name$="[_destroy]"]').val("1")
	$card.children('fieldset').remove()
	$card.hide()
	updateCardQuestionPositionValue();
	toggleEmptyStateGhostSection()
	togglePreviewButtonEnability()
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
	toggleEmptyStateGhostSection()
	togglePreviewButtonEnability()
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

function toggleEmptyStateGhostSection() {
	$ghostMessage = $('[data-target="empty-state-ghost-section"]')
	$questionsWrapper = $('[data-target="questions-wrapper"]')
	if($questionsWrapper.length > 0 && $questionsWrapper.children('.question-form:visible').length > 0) {
		$ghostMessage.hide()
	} else {
		$ghostMessage.show()
	}
}

function togglePreviewButtonEnability() {
	$previewButton = $('[data-behaviour="show-questions-preview"]');
	$questionsWrapper = $('[data-target="questions-wrapper"]');
	if($questionsWrapper.length > 0 && $questionsWrapper.children('.question-form:visible').length > 0) {
		$previewButton.prop('disabled', false);
		$previewButton.toggleClass('button--disabled', false);
	} else {
		$previewButton.prop('disabled', true);
		$previewButton.toggleClass('button--disabled', true);
	}
}

$(document).on('click', '[data-behaviour="show-questions-preview"]', function(e) {
	var $questionsPreviewWrapper = $('[data-target="questions-preview-wrapper"]')
	var $questionPreviewTemplate = $($('[data-target="question-preview-template"').html());
	var $fieldsets = $('[data-target="questions-wrapper"]').children('.question-form:visible');

	$questionsPreviewWrapper.empty()

	if ($fieldsets.length > 0) {
		$fieldsets.each(function(idx) {
			var name = $(this).find('input[name$="[name]"]').val();
			if (name === '') {
				return;
			}
			var valueType = $(this).find('select[name$="[value_type]"]').val();
			var isEmptyable = $(this).find('input[name$="[is_emptyable]"]').val();
			$clonedQuestionPreviewTemplate = $questionPreviewTemplate.clone()

			$clonedQuestionPreviewTemplate.find('p').text(name);
			$clonedQuestionPreviewTemplate.find('p').append(
				'<span class="mini-label">' + valueType + '</span>'
			);
			if (isEmptyable == '0') {
				$clonedQuestionPreviewTemplate.find('p').append(
					'<span class="mini-label">required</span>'
				);
			}

			$clonedQuestionPreviewTemplate.appendTo($questionsPreviewWrapper);
		})

		if ($questionsPreviewWrapper.children().length > 0) {
			$questionsPreviewWrapper.closest('.modal').fadeIn(200);
		}
	}
})

$(document).on('click', '.modal', function(e) {
	$(this).fadeOut(200);
})
