$ ->
  # Initialize bootstrap flash messages
  $(".alert").alert()
  $('.submit_button').each ->
    $(@).wrap "<div class='form-actions'>"
  formatDates()
      
getPrettyDateTime = (date) ->
  date.toString('MMMM d, yyyy - H:mm')
getPrettyDate = (date) ->
  date.toString('MMMM d, yyyy')
window.formatDates = ->
  $('.utc-date-time').each ->
    $(@).text(getPrettyDateTime((new Date($(@).text() * 1000))))
  $('.utc-date').each ->
    $(@).text(getPrettyDate((new Date($(@).text() * 1000))))