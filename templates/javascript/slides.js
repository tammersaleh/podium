$(function() {
  var hash = window.location.hash;
  var number = 0;
  if (hash != "") { number = hash.split("_")[1]; }
  focusSlide($(".slide").eq(number));
  document.onkeydown = keyDown;
});

function focusSlide($slide) {
  if ($slide.first().hasClass("slide")) {
    window.location.hash = "#slide_" + $(".slide").index($slide);
    $(".slide").removeClass("current_slide");
    $slide.addClass("current_slide");
    centerSlide();
  };
};

function next() {
  if ($(".current_slide .inc:hidden").length > 0) {
    $(".current_slide .inc:hidden").first().show();
  } else {
    focusSlide($(".current_slide").next());
  }
}

function prev() {
  focusSlide($(".current_slide").prev());
}

function centerSlide() {
  var slide_height = $(".current_slide").height()
  var mar_top = (0.5 * parseFloat($("#slides").height())) - (0.5 * parseFloat(slide_height))
  $(".current_slide").css('margin-top', mar_top)
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
  } else if (key == 37 || key == 38) { 
    prev();
  }
  return false 
}
