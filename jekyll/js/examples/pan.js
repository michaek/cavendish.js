$(function(){

  $('.cavendish').cavendish({
    slideSelector: '.cavendish-navigation > ol > li',
    use_plugins: ['player', 'pager', 'pan'],
    panSelector: '.cavendish-background ol.slides'
  });

})
