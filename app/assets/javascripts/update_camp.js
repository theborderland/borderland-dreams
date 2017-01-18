$(document).ready(function() {

    $('#save-camp').click(function() {
        $('#camp-form').submit();
    });

    $('#done-camp').click(function() {
        $('#camp-form').append('<input type="hidden" name="done" value="1" />');
        $('#camp-form').submit();
    });
});