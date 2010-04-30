$(function(){
  $(".slide:has(img)").addClass("with_image")

  // Fancy Ampersands
  $(":header:contains('&')").each(function(){
    $(this).html($(this).html().replace(/&amp;/, "<span class='ampersand'>&amp;</span>"))
  });
});

