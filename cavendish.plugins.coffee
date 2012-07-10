$ = jQuery

class CavendishPlugin
  constructor: (cavendish) ->
    @cavendish = cavendish
  setup: ->
  transition: ->
  defaults:
    class_names:
      active:   'active'
      disabled: 'disabled'

class CavendishEventsPlugin extends CavendishPlugin
  setup: ->
    @cavendish.show.trigger('cavendish-setup', [@cavendish])
  transition: ->
    @cavendish.show.trigger('cavendish-transition', [@cavendish])

class CavendishPagerPlugin extends CavendishPlugin
  setup: ->
    @pager = $('.cavendish-pager')
    @pager.find('a').each (index, el) =>
      $(el).click =>
        @cavendish.goto(index)
        false

  transition: ->
    @pager.find('li')
      .removeClass(@cavendish.options.class_names.active)
      .eq(@cavendish.index)
      .addClass(@cavendish.options.class_names.active)

class CavendishArrowsPlugin extends CavendishPlugin
  setup: ->
    @next = $('.cavendish-next').click =>
      @cavendish.next()
      false
    @prev = $('.cavendish-prev').click => 
      @cavendish.prev()
      false

  transition: ->
    unless @cavendish.options.loop
      last = @cavendish.index + 1 == @cavendish.length
      @next.toggleClass @cavendish.options.class_names.disabled, last
      @prev.toggleClass @cavendish.options.class_names.disabled, @cavendish.index == 0

class CavendishPanPlugin extends CavendishPlugin
  setup: ->
    @background = $('.cavendish-background ol.slides')
    @background.children().each (index, el) =>
      $(el).css('left', index*100+'%')
  transition: ->
    @background.css('left', (@cavendish.index * -100)+'%')

# Expose our plugins.
$.fn.cavendish.plugins =
  events:   CavendishEventsPlugin
  pager:    CavendishPagerPlugin
  arrows:   CavendishArrowsPlugin
  pan:      CavendishPanPlugin