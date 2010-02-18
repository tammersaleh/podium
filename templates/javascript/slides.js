$(function() {
  setupSlideThumbnails();
  focusFirstSlide();
  document.onkeydown = keyDown;
});

function setupSlideThumbnails() {
  $('<div id="thumbnails"></div>').html($("#slides").html()).appendTo("body");
  $('#thumbnails .slide').hover(function() { $(this).addClass("hover")   }, 
                                      function() { $(this).removeClass("hover")});
  $('#thumbnails .slide').click(function() { 
    focusSlide($("#slides .slide").eq($("#thumbnails .slide").index($(this))));
    toggleThumbs();
  });
  toggleThumbs();
};

function toggleThumbs() {
  if ($('#thumbnails').is(':visible')) {
    $('#thumbnails').hide();
    $('#slides').show();
  } else {
    $('#thumbnails').show();
    $('#slides').hide();
  }
};

function focusFirstSlide() {
  var hash = window.location.hash;
  var number = 0;
  if (hash != "") { number = hash.split("_")[1]; }
  focusSlide($("#slides .slide").eq(number));
}

function focusSlide($slide) {
  if ($slide.first().hasClass("slide")) {
    window.location.hash = "#slide_" + $("#slides .slide").index($slide);
    $("#slides .slide").removeClass("current");
    $slide.addClass("current");

    $thumb = $("#thumbnails .slide").eq($("#slides .slide").index($slide))
    $("#thumbnails .slide").removeClass("current");
    $thumb.addClass("current");
    centerSlide();
  };
};

function next() {
  if ($("#slides .current .inc:hidden").length > 0) {
    $("#slides .current .inc:hidden").first().show();
  } else {
    focusSlide($("#slides .current").next());
  }
}

function prev() {
  focusSlide($("#slides .current").prev());
}

function centerSlide() {
  var slide_height = $("#slides .current").height()
  var top = (0.5 * parseFloat($("#slides").height())) - (0.5 * parseFloat(slide_height))
  $("#slides .current").css('padding-top', top)
  $("#slides .current").css('padding-bottom', top)
}

//  See e.g. http://www.quirksmode.org/js/events/keys.html for keycodes
function keyDown(event)
{
  var key = event.keyCode;

  if (event.ctrlKey || event.altKey || event.metaKey)
     return true;

  console.log('key: ' + key)

  if (key == 32 || key == 39 || key == 40) { 
    next();
  } else if (key == 67) { 
    toggleThumbs();
  } else if (key == 37 || key == 38) { 
    prev();
  } else {
    return true;
  }
  return false 
}
