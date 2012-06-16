chars_remaining_suffix = 'characters remaining'
tweet_pre_length = 0
dialog_tweet_pre_length = 0
MAX_TWEET_CHARS = 140
MAX_SCREEN_NAMES_PER_QUERY = 100 # Enforced by twitter API

# Appropriately show or hide the textarea for custom enter and exit tweets
hide_or_show_custom_tweets = ->
  if $('#doghouse_canned_enter_tweet_id').val() == 'custom'
    $('#doghouse_enter_tweet').parent().show()
  else
    $('#doghouse_enter_tweet').parent().hide()
  if $('#doghouse_canned_exit_tweet_id').val() == 'custom'
    $('#doghouse_exit_tweet').parent().show()
  else
    $('#doghouse_exit_tweet').parent().hide()

# Show enter and exit tweet previews
set_previews = ->
  set_preview('enter')
  set_preview('exit')

# Set tweet preview for specific tweet type (enter or exit)
set_preview = (type) ->
  screen_name = $('#doghouse_screen_name').val()
  canned_id_val = $("#doghouse_canned_#{type}_tweet_id").val()
  # Show a preview if a person is selected and the canned tweet isn't none. Hide it otherwise
  if screen_name and canned_id_val != 'none'
    if canned_id_val == 'custom'
      $("##{type}_tweet_preview").show()
      $("##{type}_tweet_preview_text").text "@#{screen_name} #{$("#doghouse_#{type}_tweet").val()}"
    else
      $("##{type}_tweet_preview").show()
      $("##{type}_tweet_preview_text").text "@#{screen_name} #{$('option:selected', "#doghouse_canned_#{type}_tweet_id").attr('data-text')}"
  else
    $("##{type}_tweet_preview").hide()

# Appropriately enable or disable the add to doghouse form submit button
# Only enabled if a person is selected and the doghouse duration is greater than 0
set_enabled_disabled_submit = ->
  duration_minutes = (Number) $('#doghouse_duration_minutes').val()
  if $('#doghouse_screen_name').val() and duration_minutes > 0
    $('#create_doghouse_submit').removeAttr 'disabled'
  else
    $('#create_doghouse_submit').attr 'disabled', true

# Reset the doghouse form after it is submitted
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

# Set the countdowns for all of the entries in the doghouse
window.set_countdowns = ->
  $('.countdown').each ->
    $(this).countdown {until: new Date($(this).attr('data-until-time') * 1000), format: 'dHM'}

# Set up the actions for the doghouse edit dialog
window.dialog_initializers = ->
  # On show, determine number of characters remaining for the tweet
  $('.doghouse-dialog').on 'show', ->
    dialog_tweet_pre_length = $(this).attr('data-tweet-pre-length')
    $('.dialog_tweet_text').keyup()
    $('.dialog_tweet_text').attr('maxlength', MAX_TWEET_CHARS - dialog_tweet_pre_length)
  # Update the chars remaining hint text while the user types a tweet
  $('.dialog_tweet_text').on 'keyup', ->
    $(this).next().text "#{MAX_TWEET_CHARS - dialog_tweet_pre_length - $(this).val().length} #{chars_remaining_suffix}"
  # Hide the dialog when the form is submitted
  $('form.dialog-form').live "ajax:beforeSend", (event,xhr,status) ->
    $('.doghouse-dialog').modal 'hide'

# Put the following screen names in the selector for the user to put in the doghouse
put_screen_names_in_select = (screen_names) ->
  $('#doghouse_screen_name').select2 {placeholder: 'Select User'}
  for screen_name in screen_names
    $('#doghouse_screen_name').append("<option value='#{screen_name}'>@#{screen_name}</option>")

# On page loaded function
$ ->
  # Initialize the select2 plugin for the select user to doghouse selector
  $('#doghouse_screen_name').select2 {
    placeholder: "Loading Following..."
  }
  
  # Callback when user to put in doghouse changes
  $('#doghouse_screen_name').on 'change', ->
    # Calculate number of characters remaining for tweet, show the tweet hint and set maxlength for the textfield
    tweet_pre_length = $('#doghouse_screen_name').val().length + 2 # '@' sign and space after the screen_name
    chars_remaining = MAX_TWEET_CHARS - tweet_pre_length
    chars_remaining_text = "#{chars_remaining} #{chars_remaining_suffix}"
    $('.tweet_hint').text chars_remaining_text
    $('.tweet_text').attr('maxlength', chars_remaining)
    set_previews()
    set_enabled_disabled_submit()
  
  # Update the chars remaining hint and tweet preview while the user types a tweet
  $('.tweet_text').on 'keyup', ->
    $(this).next().text "#{MAX_TWEET_CHARS - tweet_pre_length - $(this).val().length} #{chars_remaining_suffix}"
    set_previews()
  
  # Set whether the form submit button should be enabled based on the duration (must be greater than 0)
  $('#doghouse_duration_minutes').on 'keyup', ->
    set_enabled_disabled_submit()
  $('#doghouse_duration_minutes').on 'click', ->
    set_enabled_disabled_submit()
  
  # Initialize whether to show custom tweet textarea and previews
  hide_or_show_custom_tweets()
  set_previews()
  
  # Set whether to show custom tweet textarea and previews when user changes canned tweet selector
  $('.canned-tweet-id').on 'change', ->
    hide_or_show_custom_tweets()
    set_previews()
  set_enabled_disabled_submit()
  
  # Reset the form after user is added to doghouse
  $('form#new_doghouse').live "ajax:beforeSend", (event,xhr,status) ->
    reset_new_doghouse_form()
    $('#create_doghouse_submit').attr 'disabled', true
    # Change the text on the submit button. Will be changed back when result is returned.
    $('#create_doghouse_submit').val 'Adding to DogHouse...'
  
  # Other initializations
  set_countdowns()
  dialog_initializers()
  
  # Fill the screen name select box with people the user follows on twitter
  jQuery.getJSON '/get_following_ids', {user_id: $('#current_user').attr('data-id')}, (following_ids) ->
    index = 0
    while index < following_ids.length
      jQuery.getJSON '/get_screen_names', {ids: following_ids[index...(index+MAX_SCREEN_NAMES_PER_QUERY)]}, (screen_names) ->
        put_screen_names_in_select screen_names
      index += MAX_SCREEN_NAMES_PER_QUERY
  
  