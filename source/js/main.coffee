//= require "vendor/_zepto.js"
//= require "_plugins.js"

Zepto ->
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
    console.log next
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
