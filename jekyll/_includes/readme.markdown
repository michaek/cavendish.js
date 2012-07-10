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

# Plugins

Cavendish provides a few interaction plugins that you can choose to use - none are enabled by default. You can enable them with the use_plugins option:

    $('.cavendish').cavendish({use_plugins: ['pager']});

### Pager

Connects a list of links to your slides, and clicking on a link navigates to the slide. It doesn't try to generate a pager for you, so you're able to provide exactly the HTML you need to create the effect you're going for.

### Arrows

Connects a previous and next link to the prev() and next() methods on your cavendish object. If you've set the loop option to false, the links will get a disabled class when you get to the beginning or end - otherwise you can click around the list forever.

### Pan

This is a slightly unusual feature, but it's one I use a lot so I included it! It takes an element within the cavendish parent element, and positions it absolutely based on the current slide index. This isn't very configurable now, but it could also be useful for a parallax effect.

### Events

Exposes cavendish events so you can hook in your own code without writing a cavendish plugin of your own. Once it's enabled, events are fired on the cavendish parent element:

* cavendish-setup: When the cavendish element is initialized, but before any transitions have been triggered
* caventish-transition: On each transition between slides. It's also fired on the first slide after setup.