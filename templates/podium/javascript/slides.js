$(function() { Podium.setup(); });

Podium = {
  setup: function() {
    Thumbnails.setup();
    Sections.setup();
    Slides.focusFirst();
    document.onkeydown = Podium.keyDown;
  },

  hideAll: function() {
    $('#thumbnails').hide();
    $('#sections').hide();
    $('#slides').hide();
  },

  //  See e.g. http://www.quirksmode.org/js/events/keys.html for keycodes
  keyDown: function(event)
  {
    var key = event.keyCode;

    if (event.ctrlKey || event.altKey || event.metaKey)
       return true;

    console.log('key: ' + key)

    if (key == 32 || key == 39 || key == 40) { 
      Slides.next();
    } else if (key == 37 || key == 38) { 
      Slides.prev();
    } else if (key == 67) { 
      Thumbnails.toggle();
    } else if (key == 83) { 
      Sections.toggle();
    } else if (key == 27) { 
      Slides.show();
    } else {
      return true;
    }
    return false 
  },
};

Slides = {
  show: function() {
    Podium.hideAll();
    $('#slides').show();
  },

  focusFirst: function() {
    var hash = window.location.hash;
    var number = 0;
    if (hash != "") { number = hash.split("_")[1]; }
    Slides.focus($("#slides .slide").eq(number));
  },

  focus: function focus($slide) {
    if ($slide.first().hasClass("slide")) {
      window.location.hash = Slides.hash($slide);

      $("#slides .slide").removeClass("current");
      $("#thumbnails .slide").removeClass("current");
      $("#sections .section").removeClass("current");

      $slide.addClass("current");

      Sections.setCurrent();
      Thumbnails.setCurrent();
      Slides.center();
    };
  },

  hash: function($slide) {
    return "#slide_" + $("#slides .slide").index($slide);
  },

  next: function() {
    if ($("#slides .current .inc:hidden").length > 0) {
      $("#slides .current .inc:hidden").first().show("fast");
    } else {
      Slides.focus($("#slides .current").next());
    }
  },

  prev: function() {
    Slides.focus($("#slides .current").prev());
  },

  center: function() {
    var slide_height = $("#slides .current").height()
    var top = (0.5 * parseFloat($("#slides").height())) - (0.5 * parseFloat(slide_height))
    $("#slides .current").css('padding-top', top)
    $("#slides .current").css('padding-bottom', top)
  },
};

Thumbnails = {
  setup: function() {
    $('<div id="thumbnails"></div>').html($("#slides").html()).appendTo("body");
    $('#thumbnails .slide').hover(function() { $(this).addClass("hover")   }, 
                                  function() { $(this).removeClass("hover")});
    $('#thumbnails .slide').click(function() { 
      Slides.focus($("#slides .slide").eq($("#thumbnails .slide").index($(this))));
      Thumbnails.toggle();
    });
    Thumbnails.toggle();
  },

  toggle: function() {
    if ($('#thumbnails').is(':visible')) {
      Slides.show();
    } else {
      Podium.hideAll();
      $('#thumbnails').show();
    }
  },

  setCurrent: function() {
    $thumb = $("#thumbnails .slide").eq($("#slides .slide").index($("#slides .slide.current")));
    $thumb.addClass("current");
  },
};

Sections = {
  setup: function() {
    $('<div id="sections"><h2>Sections:</h1><ol></ol></div>').appendTo("body");

    $("#slides .slide").each(function(){ 
      var id = $(this).attr("id");
      if (id) {
        var human = String(id).replace(/_/g, ' ');
        $('<li class="section" rel="' + id + '">' + human + '</li>').appendTo("#sections");
      }
    });

    $('#sections .section').hover(function() { $(this).addClass("hover")   }, 
                                  function() { $(this).removeClass("hover")});
    $('#sections .section').click(function() { 
      Slides.focus($("#slides .slide#" + $(this).attr('rel')));
      Sections.toggle();
    });

    Sections.toggle();
  },

  toggle: function() {
    if ($('#sections').is(':visible')) {
      Slides.show();
    } else {
      Podium.hideAll();
      $('#sections').show();
    }
  },

  setCurrent: function() {
    $slide = $("#slides .slide.current");
    if ($slide.attr("id")) {
      $section = $("#sections .section[rel='" + $slide.attr("id") + "']");
      $section.addClass("current");
    }
  },

};

