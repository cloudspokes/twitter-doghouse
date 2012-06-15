chars_remaining_suffix = 'characters remaining'
tweet_pre_length = 0
MAX_TWEET_CHARS = 140

hide_or_show_custom_tweets = ->
  if $('#doghouse_canned_enter_tweet_id').val() == 'custom'
    $('#doghouse_enter_tweet').parent().show()
  else
    $('#doghouse_enter_tweet').parent().hide()
  if $('#doghouse_canned_exit_tweet_id').val() == 'custom'
    $('#doghouse_exit_tweet').parent().show()
  else
    $('#doghouse_exit_tweet').parent().hide()

set_previews = ->
  set_preview('enter')
  set_preview('exit')

set_preview = (type) ->
  screen_name = $('#doghouse_screen_name').val()
  if screen_name
    canned_id_val = $("#doghouse_canned_#{type}_tweet_id").val()
    if canned_id_val == 'custom'
      $("##{type}_tweet_preview").show()
      $("##{type}_tweet_preview_text").text "@#{screen_name} #{$("#doghouse_#{type}_tweet").val()}"
    else if canned_id_val == 'none'
      $("##{type}_tweet_preview").hide()
    else
      $("##{type}_tweet_preview").show()
      $("##{type}_tweet_preview_text").text "@#{screen_name} #{$('option:selected', "#doghouse_canned_#{type}_tweet_id").attr('data-text')}"

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
    set_previews()
  
  $('.tweet_text').on 'keyup', ->
    $(this).next().text "#{MAX_TWEET_CHARS - tweet_pre_length - $(this).val().length} #{chars_remaining_suffix}"
    set_previews()
  
  hide_or_show_custom_tweets()
  $('.canned-tweet-id').on 'change', ->
    hide_or_show_custom_tweets()
    set_previews()
  $('.tweet-preview').hide()
    
  
  