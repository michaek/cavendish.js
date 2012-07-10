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
      .addClass @options.class_names.show

    for plugin in @plugins
      plugin.setup()
      @options = $.extend(true, {}, plugin.defaults, @options)

    @goto 0
    @slides.not(@current).addClass @options.class_names.slide.before

  next: ->
    index = @index + 1
    if index >= @length && @options.loop then index = 0
    @goto(index)

  prev: ->
    index = @index - 1
    if index < 0 && @options.loop then index = @length - 1
    @goto(index)

  goto: (index) ->
    if !@slides[index]? then return
    @index = index
    if @current? then @last = @current
    @current = @slides.eq(@index)
    classes = @options.class_names.slide
    @slides.removeClass (name for key, name of classes).join(' ')
    @last.addClass classes.after
    @current.addClass classes.on
    # Add left and right classes.
    @slides.each (index, slide) =>
      if index < @index
        $(slide).addClass classes.left
      else if index > @index
        $(slide).addClass classes.right
    # Reset all but the last and current to their before state.
    @slides.not(@last).not(@current).addClass classes.before

    for plugin in @plugins
      plugin.transition()

# The Cavendish player class, which adds auto-advance options.
class CavendishPlayer extends Cavendish
  constructor: (show, options) ->
    options = $.extend(true, {}, @defaults, options)
    super show, options

  initialize: ->
    super
    if @options.player_pause then @show.hover (=> @stop()), (=> @start())
    if @options.player_start then @start()

  start: ->
    @show.addClass(@options.class_names.playing)
    @timeout = setInterval (=> @next()), @options.slideTimeout

  stop: ->
    @show.removeClass(@options.class_names.playing)
    clearInterval(@timeout)

  defaults:
    player_start: true
    player_pause: true
    slideTimeout: 2000
    class_names:
      playing: 'cavendish-playing'


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

# Expose a jQuery method for our slideshow.
$.fn.cavendish = (options) ->
  unless typeof options == 'string'
    # Set up the slideshow.
    options = $.extend(true, {}, defaults, options)
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
  loop: true
  slideSelector: '> ol > li'
  use_plugins: []
  class_names:
    show:     'cavendish-slideshow'
    slide:
      left:   'cavendish-left'
      right:  'cavendish-right'
      on:     'cavendish-onstage'
      before: 'cavendish-before'
      after:  'cavendish-after'

# Expose our plugins.
plugins = $.fn.cavendish.plugins =
  events:   CavendishEventsPlugin
  pager:    CavendishPagerPlugin
  arrows:   CavendishArrowsPlugin
  pan:      CavendishPanPlugin