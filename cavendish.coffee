$ = jQuery

class Cavendish
  version: '0.0.1'

  constructor: (@show, @options) ->
    @slides = @show.find @options.slideSelector
    if @slides.length > 0
      @initialize()

  initialize: ->
    @plugins = $.map @options.use_plugins, (name) =>
      new $.fn.cavendish.plugins[name](this)

    @last = $()
    @length = @slides.length
    @show
      .data('cavendish', this)
      .addClass @options.class_names.show

    $.each @plugins, -> @setup()

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

    $.each @plugins, -> @transition()

# Expose a jQuery method for our slideshow.
$.fn.cavendish = (options) ->
  unless typeof options == 'string'
    # Set up the slideshow.
    options = $.extend(true, {}, defaults, options)
    return this.each ->
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

# Initialize our plugins.
$.fn.cavendish.plugins = {}