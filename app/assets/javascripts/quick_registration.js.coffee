#quick_registration = ->

$(document).on 'turbolinks:load', ->
  $("#quick_registration_user").change ->
    if $('#quick_registration_user :selected').val() == ''
      $('div.quick_registration_email').show()
    else
      $('div.quick_registration_email').hide()
