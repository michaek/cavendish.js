# Cavendish.js

Cavendish is intended to be a very simple slide manager based on CSS transitions. Initializing Cavendish sets up an iterator for your slides, which applies classes to your slides based on their relationship to the current slide. Everything else is up to you!

Cavendish doesn't try to polyfill for old browsers, or to provide any extra interaction - it's just meant to provide a platform for custom interaction by managing the state of your slides. I think you'll find it refreshing!

I noticed recently that this approach is very similar to the approach of [Bootstrap's Carousel](http://twitter.github.io/bootstrap/javascript.html#carousel). If you're already using Bootstrap, it probably makes sense to use that instead.

# Usage

Cavendish is written in Coffeescript, but it works like an ordinary jQuery plugin:

    $('.slideshow').cavendish();

We can also send special commands.

    $('.cavendish').cavendish('prev');

Or get a reference to the Cavendish object.

    var cavendish = $('.cavendish').cavendish('cavendish');
    cavendish.prev();

# Plugins

Cavendish provides a few interaction plugins that you can choose to use - none are enabled by default. You can enable them with the use_plugins option:

    $('.cavendish').cavendish({use_plugins: ['player']});

### Player

Auto-advances between slides and pauses on hover. You can call start and stop methods on the plugin from the Cavendish object. It's a little verbose, currently:

    var cavendish = $('.cavendish').cavendish('cavendish');
    cavendish.plugins['player'].start();

In the initial version of Cavendish, the player was part of the core library and enabled by default. Now it's just another plugin, and you've got to include it in your cavendish() initialization, or override the defaults by setting:

    $.fn.cavendish.defaults['use_plugins'] = ['player']

### Pager

Connects a list of links to your slides, and clicking on a link navigates to the slide. It doesn't try to generate a pager for you, so you're able to provide exactly the HTML you need to create the effect you're going for.

### Arrows

Connects a previous and next link to the prev() and next() methods on your cavendish object. If you've set the loop option to false, the links will get a disabled class when you get to the beginning or end - otherwise you can click around the list forever.

### Pan

This is a slightly unusual feature, but it's one I use a lot so I included it! It takes an element within the cavendish parent element, and positions it absolutely based on the current slide index. This can also be used as a parallax effect, if you set the panFactor option to a smaller number - it's 1 by default, which represents the entire width of the slideshow.

### Events

Exposes cavendish events so you can hook in your own code without writing a cavendish plugin of your own. Once it's enabled, events are fired on the cavendish parent element:

* cavendish-setup: When the cavendish element is initialized, but before any transitions have been triggered
* caventish-transition: On each transition between slides. It's also fired on the first slide after setup.
