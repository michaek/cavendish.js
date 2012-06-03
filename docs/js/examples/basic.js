$(function(){
  var $pager = $('.cavendish-pager');

  $('.cavendish')
    // This allows us to set up a pager, if we feel so inclined.
    .bind('cavendish-slide-init', function(e, index, slide, cavendish) {
      $pager.children().eq(index)
        .click(function(){
          cavendish.goto(index)
          return false
        })
    })
    .cavendish()
    // Maybe we'd like to do something special for a transition.
    // In this example, we set the height based on the slide number.
    .bind('cavendish-transition', function(e, c) {
      var top = c.index * 10;
      $(this).children().css('top', top);

      $pager.children()
        .removeClass('active')
        .eq(c.index)
        .addClass('active');

    })

  // We can also send commands.
  // $('.cavendish').cavendish('prev');

  // Or get a reference to the Cavendish object.
  // var cavendish = $('.cavendish').cavendish('cavendish');
  // cavendish.prev();
})
