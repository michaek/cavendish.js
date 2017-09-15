(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
	typeof define === 'function' && define.amd ? define(factory) :
	(global.cavendish = factory());
}(this, (function () { 'use strict';

var prefix = 'cavendish-';

var classes = ['slide', 'onstage', 'left', 'right', 'before', 'after', 'animating', 'pager', 'navigation'];
var defaultOptions = {};
classes.forEach(function(name) { defaultOptions[name+'Class'] = prefix + name; });

function toggle(element, on, off) {
	if (off) {
		for (var i=0; i<off.length; i++) {
			if (off[i]) {
				element.classList.toggle(off[i], false);
			}
		}
	}
	if (on) {
		for (var i=0; i<on.length; i++) {
			if (on[i]) {
				element.classList.toggle(on[i], true);
			}
		}
	}
}

function cavendish(root, options) {
	options = Object.assign({}, defaultOptions, options);
	var slides = [].slice.call(root.getElementsByClassName(options.slideClass));
	var pager = [].slice.call(root.getElementsByClassName(options.pagerClass))[0];
	var navigation = [].slice.call(root.getElementsByClassName(options.navigationClass))[0];
	var clearClasses = ['onstage', 'left', 'right', 'before', 'after'].map(function(name) { return options[name+'Class'] });
	var current;
	var interval;
	var pan;
	var panFactor = 1/slides.length;
	if (options.panFactor) {
		panFactor = options.panFactor;
	}
	if (options.panSelector) {
		pan = root.querySelector(options.panSelector);
		if (pan) {
			// MAke room for all the slides.
			pan.style.width = (1 + (slides.length - 1) * panFactor * slides.length) * 100 + '%';
		}
	}
	if (pager) {
		var pagination = document.createElement('nav');
		slides.forEach(function(slide, i) {
			var link = document.createElement('a');
			link.innerText = i + 1;
			link.addEventListener('click', function() {
				slider.goto(i);
			});
			pagination.appendChild(link);
		});
		pager.appendChild(pagination);
	}
	if (navigation) {
		var nav = document.createElement('nav');['prev', 'next'].forEach(function(direction) {
			var link = document.createElement('a');
			link.innerText = direction;
			link.addEventListener('click', function() {
				slider[direction]();
			});
			nav.appendChild(link);
		});
		navigation.appendChild(nav);
	}

	var slider = {
		goto: function(index) {
			if (index === current) {
				return
			}
			var i;
			for (i=0;i<slides.length;i++) {
				if (i !== index) {
					toggle(slides[i], [
						i < index ? options.leftClass : options.rightClass,
						i !== current ? options.beforeClass : '',
					], clearClasses);
				}
			}
			toggle(slides[index], [options.onstageClass], clearClasses);
			if (current != null) {
				toggle(slides[current], [options.afterClass], [options.onstageClass]);
			}
			if (pan != null) {
				pan.style.transform = 'translateX(' + (index * -100 * panFactor) + '%)';
			}
			current = index;
		},

		prev: function() {
			var prev = current - 1;
			slider.goto(prev >= 0 ? prev : (options.loop ? slides.length - 1 : 0));
		},

		next: function() {
			var next = current + 1;
			slider.goto(next >= slides.length ? (options.loop ? 0 : slides.length - 1) : next);
		},

		start: function() {
			toggle(root, [options.animatingClass]);
			interval = window.setInterval(slider.next, 2000);
		},

		stop: function() {
			toggle(root, null, [options.animatingClass]);
			window.clearInterval(interval);
		},

	};

	slider.goto(0);
	if (options.play) {
		slider.start();
		root.addEventListener('mouseenter', function(e) {if (e.target === e.currentTarget) { slider.stop(); }});
		root.addEventListener('mouseleave', function(e) {if (e.target === e.currentTarget) { slider.start(); }});
	}

	return slider
}

return cavendish;

})));
