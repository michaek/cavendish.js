$(function(){
  var $pager = $('.cavendish-pager');

  $('.cavendish')
    // This allows us to set up a pager, if we feel so inclined.
    .bind('cavendish-slide-init', function(e, index, slide, cavendish) {
      $pager.find('a').eq(index)
        .click(function(){
          cavendish.goto(index)
          return false
        })
    })
    .cavendish({player: false})
    .bind('cavendish-transition', function(e, c) {
      $pager.find('li')
        .removeClass('active')
        .eq(c.index)
        .addClass('active');
    })

})
