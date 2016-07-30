// ------------------------------------------------------------
// Mobile Menu
// ------------------------------------------------------------

(function ($) {
  $.fn.mobileMenu = function(options) {
    options = $.extend({}, $.fn.mobileMenu.options, options);
    return this.each(function() {

      // mobileMenu vars
      var elem = $(this),

          // Set default options
          toggleElem = options.toggleElem,
          toggleClass = options.toggleClass;

      // mobileMenu code
      elem.click(function(){
        $(toggleElem).toggleClass(toggleClass);
      });

    });
  };

  // mobileMenu default options
  $.fn.mobileMenu.options = {
    toggleElem: 'body',
    toggleClass: 'menu-active'
  };

})(jQuery);

$(document).ready(function() {
  $('.popup-gallery').magnificPopup({
    delegate: 'a',
    type: 'image',
    tLoading: 'Loading image #%curr%...',
    mainClass: 'mfp-img-mobile',
    gallery: {
      enabled: true,
      navigateByImgClick: true,
      preload: [0,1] // Will preload 0 - before current, and 1 after the current image
    },
    image: {
      tError: '<a href="%url%">The image #%curr%</a> could not be loaded.',
      titleSrc: function(item) {
        return item.el.attr('title') + '<small>by Marsel Van Oosten</small>';
      }
    }
  });
});
