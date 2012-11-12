$ = jQuery

class CavendishPlugin
  constructor: (cavendish) ->
    @cavendish = cavendish
    @options = @cavendish.options = $.extend true, {}, @defaults(), @cavendish.options
  setup: ->
  transition: ->
  extensions: -> []
  defaults: ->
    class_names:
      active:   'active'
      disabled: 'disabled'

class CavendishPlayerPlugin extends CavendishPlugin
  setup: ->
    @show = @cavendish.show
    if @options.player_pause then @show.hover (=> @stop()), (=> @start())
    if @options.player_start then @start()

  start: ->
    @show.addClass(@options.class_names.playing)
    @timeout = setInterval (=> @cavendish.next()), @options.slideTimeout

  stop: ->
    @show.removeClass(@options.class_names.playing)
    clearInterval(@timeout)

  defaults: =>
    $.extend true, {}, super,
      player_start: true
      player_pause: true
      slideTimeout: 2000
      class_names:
        playing: 'cavendish-playing'

class CavendishEventsPlugin extends CavendishPlugin
  setup: ->
    @cavendish.show.trigger('cavendish-setup', [@cavendish])
  transition: ->
    @cavendish.show.trigger('cavendish-transition', [@cavendish])

class CavendishPagerPlugin extends CavendishPlugin
  setup: ->
    @pager = $(@cavendish.options.pagerSelector, @cavendish.show)
    @pager.find(@cavendish.options.pagerItemSelector).each (index, el) =>
      $(el).click =>
        @cavendish.goto(index)
        false

  transition: ->
    @pager.find(@cavendish.options.pagerItemSelector)
      .removeClass(@cavendish.options.class_names.active)
      .eq(@cavendish.index)
      .addClass(@cavendish.options.class_names.active)

  defaults: ->
    $.extend true, {}, super,
      pagerSelector:      '.cavendish-pager'
      pagerItemSelector:  'li'

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
    @background = @cavendish.show.find @cavendish.options.panSelector
    @background.find(@cavendish.options.panChildSelector).each (index, el) =>
      $(el).css('left', index*100+'%')

  transition: ->
    @background.css('left', (@cavendish.index * -100 * @cavendish.options.panFactor)+'%')

  defaults: ->
    $.extend true, {}, super,
      panFactor:        1
      panSelector:      '.cavendish-pan'
      panChildSelector: '> li'

# Expose our plugins.
$.fn.cavendish.plugins =
  player:   CavendishPlayerPlugin
  events:   CavendishEventsPlugin
  pager:    CavendishPagerPlugin
  arrows:   CavendishArrowsPlugin
  pan:      CavendishPanPlugin