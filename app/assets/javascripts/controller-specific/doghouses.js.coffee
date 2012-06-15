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
  canned_id_val = $("#doghouse_canned_#{type}_tweet_id").val()
  if screen_name and canned_id_val != 'none'
    if canned_id_val == 'custom'
      $("##{type}_tweet_preview").show()
      $("##{type}_tweet_preview_text").text "@#{screen_name} #{$("#doghouse_#{type}_tweet").val()}"
    else
      $("##{type}_tweet_preview").show()
      $("##{type}_tweet_preview_text").text "@#{screen_name} #{$('option:selected', "#doghouse_canned_#{type}_tweet_id").attr('data-text')}"
  else
    $("##{type}_tweet_preview").hide()

set_enabled_disabled_submit = ->
  duration_minutes = (Number) $('#doghouse_duration_minutes').val()
  if $('#doghouse_screen_name').val() and duration_minutes > 0
    $('#create_doghouse_submit').removeAttr 'disabled'
  else
    $('#create_doghouse_submit').attr 'disabled', true

reset_new_doghouse_form = ->
  $("#doghouse_screen_name option:selected").remove()
  $('#doghouse_screen_name').select2 'val', ''
  $('#doghouse_duration_minutes').val ''
  $('#doghouse_duration_minutes_multiplier_1').click()
  $("#doghouse_canned_enter_tweet_id option:first").attr 'selected','selected'
  $("#doghouse_canned_exit_tweet_id option:first").attr 'selected','selected'
  hide_or_show_custom_tweets()
  set_previews()
  set_enabled_disabled_submit()

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
    set_enabled_disabled_submit()
  
  $('.tweet_text').on 'keyup', ->
    $(this).next().text "#{MAX_TWEET_CHARS - tweet_pre_length - $(this).val().length} #{chars_remaining_suffix}"
    set_previews()
  
  $('#doghouse_duration_minutes').on 'keyup', ->
    set_enabled_disabled_submit()
  
  hide_or_show_custom_tweets()
  set_previews()
  $('.canned-tweet-id').on 'change', ->
    hide_or_show_custom_tweets()
    set_previews()
  set_enabled_disabled_submit()
  
  $("form#new_doghouse").live "ajax:beforeSend", (event,xhr,status) ->
    reset_new_doghouse_form()
  