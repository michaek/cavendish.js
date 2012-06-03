$(function(){
  var $pager = $('.cavendish-pager');

  $('.cavendish')
    .bind('cavendish-slide-init', function(e, index, slide, cavendish) {
      slide.css('left', index*100+'%')
    })
    .cavendish()
    .bind('cavendish-transition', function(e, c) {
      var left = c.index * -100;
      $(this).children().css('left', left+'%');
    });

})
