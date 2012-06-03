# About

Cavendish is intended to be a very simple slide manager based on CSS transitions. Initializing Cavendish sets up an iterator for your slides, which applies classes to your slides based on their relationship to the current slide. Everything else is up to you!

Cavendish doesn't try to polyfill for old browsers, or to provide any extra interaction - it's just meant to provide a platform for custom interaction by managing the state of your slides. I think you'll find it refreshing!

# Usage

Cavendish is written in Coffeescript, but it works like an ordinary jQuery plugin:

    $('.slideshow').cavendish();

We can also send special commands.

    $('.cavendish').cavendish('prev');

Or get a reference to the Cavendish object.

    var cavendish = $('.cavendish').cavendish('cavendish');
    cavendish.prev();

# Player

By default, Cavendish auto-advances between slides and pauses on hover. Cavendish can be used without auto-advance by passing `player: false` in the options.