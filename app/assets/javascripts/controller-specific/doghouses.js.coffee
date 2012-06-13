chars_remaining_suffix = 'characters remaining'
tweet_pre_length = 0
MAX_TWEET_CHARS = 140

$ ->
  $('#doghouse_screen_name').select2 {
    placeholder: "Select User"
  }
  
  $('#doghouse_screen_name').on 'change', ->
    tweet_pre_length = $('#doghouse_screen_name').val().length + 2 # '@' sign and space after the screen_name
    chars_remaining = MAX_TWEET_CHARS - tweet_pre_length
    chars_remaining_text = "#{chars_remaining} #{chars_remaining_suffix}"
    $('.tweet_hint').text chars_remaining_text
    $('.tweet_text').attr('maxlength', chars_remaining)
  
  $('.tweet_text').on 'keyup', ->
    $(this).next().text "#{MAX_TWEET_CHARS - tweet_pre_length - $(this).val().length} #{chars_remaining_suffix}"