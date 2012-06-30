$(function(){
  var $pager = $('.cavendish-pager');
  var $background = $('.cavendish-background ol.slides');

  $('.cavendish')
    .bind('cavendish-slide-init', function(e, index, slide, cavendish) {

      // Duplicated from pager.js.
      $pager.find('a').eq(index)
        .click(function(){
          cavendish.goto(index)
          return false
        })

      $background.children().eq(index).css('left', index*100+'%')
    })
    .cavendish({
      slideSelector: '.cavendish-navigation > ol > li'
    })
    .bind('cavendish-transition', function(e, c) {

      // Duplicated from pager.js.
      $pager.find('li')
        .removeClass('active')
        .eq(c.index)
        .addClass('active');

      var left = c.index * -100;
      $background.css('left', left+'%');
    });

})
