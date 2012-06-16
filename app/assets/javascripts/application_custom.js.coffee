$ ->
  # Initialize bootstrap flash messages
  $(".alert").alert()
  
  # Put div around bootstrap submit button
  $('.submit_button').each ->
    $(@).wrap "<div class='form-actions'>"
      
  # Format all dates to show local timezone
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