$ = jQuery

# The basic Cavendish slides class.
class Cavendish
  constructor: (@show, @options) ->
    @slides = @show.find @options.slideSelector
    if @slides.length > 0
      @initialize()

  initialize: ->
    @plugins = for plugin_name in @options.use_plugins
      new plugins[plugin_name](this)

    @last = $()
    @length = @slides.length
    @show
      .data('cavendish', this)
      .addClass('cavendish-slideshow')

    for plugin in @plugins
      plugin.setup()

    @goto(0)
    @slides.not(@current).addClass('cavendish-before')

  next: ->
    index = @index + 1
    if index >= @length then index = 0
    @goto(index)

  prev: ->
    index = @index - 1
    if index < 0 then index = @slides.length - 1
    @goto(index)

  goto: (index) ->
    if !@slides[index]? then return
    @index = index
    if @current? then @last = @current
    @current = @slides.eq(@index)
    @slides.removeClass('cavendish-onstage cavendish-before cavendish-after cavendish-left cavendish-right')
    @last.addClass('cavendish-after')
    @current.addClass('cavendish-onstage')
    # Add left and right classes.
    @slides.each (index, slide) =>
      if index < @index
        $(slide).addClass('cavendish-left')
      else if index > @index
        $(slide).addClass('cavendish-right')
    # Reset all but the last and current to their before state.
    @slides.not(@last).not(@current).addClass('cavendish-before')

    for plugin in @plugins
      plugin.transition()

# The Cavendish player class, which adds auto-advance options.
class CavendishPlayer extends Cavendish
  initialize: ->
    super
    if @options.player_pause then @show.hover (=> @stop()), (=> @start())
    if @options.player_start then @start()

  start: ->
    @show.addClass('cavendish-playing')
    @timeout = setInterval (=> @next()), @options.slideTimeout

  stop: ->
    @show.removeClass('cavendish-playing')
    clearInterval(@timeout)


class CavendishPlugin
  constructor: (cavendish) ->
    @cavendish = cavendish
  setup: ->
  transition: ->

class CavendishEventsPlugin extends CavendishPlugin
  setup: ->
    @cavendish.show.trigger('cavendish-setup', [@cavendish])
  transition: ->
    @cavendish.show.trigger('cavendish-transition', [@cavendish])

class CavendishPagerPlugin extends CavendishPlugin
  setup: ->
    @pager = $('.cavendish-pager')
    @pager.find('a').each (index, el) =>
      $(el).click => @cavendish.goto(index)

  transition: ->
    @pager.find('li')
      .removeClass('active')
      .eq(@cavendish.index)
      .addClass('active')

class CavendishPanPlugin extends CavendishPlugin
  setup: ->
    @background = $('.cavendish-background ol.slides')
    @background.children().each (index, el) =>
      $(el).css('left', index*100+'%')
  transition: ->
    @background.css('left', (@cavendish.index * -100)+'%')

# Expose a jQuery method for our slideshow.
$.fn.cavendish = (options) ->
  unless typeof options == 'string'
    # Set up the slideshow.
    options = $.extend({}, defaults, options)
    return this.each ->
      if options.player
        new CavendishPlayer $(this), options
      else
        new Cavendish $(this), options
  else 
    cavendish = $(this).data('cavendish')
    if cavendish?
      # Interpret options as a command
      switch options
        when 'next'
          cavendish.next()
        when 'prev'
          cavendish.prev()
        when 'cavendish'
          # Note: breaks chaining.
          return cavendish
    return this

# Expose jQuery defaults for our slideshow.
defaults = $.fn.cavendish.defaults =
  player: true
  player_start: true
  player_pause: true
  slideSelector: '> ol > li'
  slideTimeout: 2000
  use_plugins: []

plugins = $.fn.cavendish.plugins =
  events: CavendishEventsPlugin
  pager: CavendishPagerPlugin
  pan: CavendishPanPlugin