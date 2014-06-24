//= require "vendor/_jquery.js"
//= require "vendor/_scrollspy.js"
//= require "vendor/_affix.js"
//= require "_plugins.js"

jQuery ->
  $('.invite-form input').focus()

  # ####
  # Toggle feature panes on splash page
  # ####

  togglePane = (pane) ->
    pane.addClass('on')
    for mark,i in pane.find('.feature-pane__marks > li')
      $mark = $(mark)
      (($mark, i) ->
        setTimeout ->
          $mark.addClass('on')
        , 200 * (i+1)
      )($mark, i)

  togglePane($(".splash-body__groups > li.on"))

  nextPane = ->
    next = $('.splash-body__header li.on').next()
    if next.length > 0
      next.click()
    else
      $('.splash-body__header li:first').click()

    window.toggleSwitcher = window.setTimeout ->
      nextPane()
    , 6000

  window.toggleSwitcher = window.setTimeout ->
    nextPane()
  , 6000

  $('.splash-body__header li').click (e) ->
    window.clearTimeout(window.toggleSwitcher)

    index = $('.splash-body__header > li').index($(e.currentTarget))

    $('.splash-body__header > li, .splash-body__groups > li, .feature-pane__marks > li').removeClass('on')

    $(e.currentTarget).addClass('on')
    targetPane = $(".splash-body__groups > li:nth-child(#{index+1})")
    togglePane(targetPane)

  # ####
  # END Toggle feature panes on splash page
  # ####

  # show the register buttons if certain params are in the URL
  urlHash = document.URL.split('#')
  if urlHash.length > 1
    urlHash = urlHash[1]
    if urlHash == 'hn' || urlHash == 'register' || urlHash == 'betalist'
      $('.js-register').css('display', 'inline-block')
      $('.js-beta-invite').hide()


  $('.invite-form').submit (e) ->
    e.preventDefault()

    button = $(e.currentTarget).find('button')
    currentButtonValue = button.text()

    return if button.hasClass('disabled')

    payload =
      email: $(e.currentTarget).find('[name=email]').val()

    if $.trim(payload.email).length == 0
      alert('Please enter a valid email address.')
      return

    $.ajax
      type: 'get' # GET for now, since POST is proving more difficult to handle on the server with JSONP
      url: 'https://api.stoplight.io/invites'
      data: payload
      dataType: 'jsonp'
      beforeSend: (xhr, settings) ->
        button.text('working..').addClass('disabled')
      error: (xhr, errorType, error) ->
        alert('There was an error connecting to the StopLight API.')
      complete: ->
        button.text(currentButtonValue).removeClass('disabled')
      success: (data, status, xhr) ->
        if data.error.length
          alert(data.error)
        else
          $('.invite-form').find('input,button,.no-spam').hide()
          $('.invite-form__done').css('display','inline-block')
