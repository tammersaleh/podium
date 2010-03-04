$(function() { 
  var podium = new Podium(); 
  podium.initialize();
});

function Podium() {
  var self = this;

  self.initialize = function() {
    self.sections   = new Sections(self);
    self.slides     = new Slides(self);
    self.thumbnails = new Thumbnails(self);
    self.notes      = new Notes(self);

    self.sections.initialize();
    self.thumbnails.initialize();
    self.notes.initialize();
    self.slides.initialize();

    document.onkeydown = self.keyDown;
  };

  self.hideAll = function() {
    $('#thumbnails').hide();
    $('#sections').hide();
    $('#slides').hide();
  };

  //  See e.g. http://www.quirksmode.org/js/events/keys.html for keycodes
  self.keyDown = function(event)
  {
    var key = event.keyCode;

    if (event.ctrlKey || event.altKey || event.metaKey)
       return true;

    console.log('key: ' + key)

    if (key == 32 || key == 39 || key == 40) { 
      self.slides.next();
    } else if (key == 37 || key == 38) { 
      self.slides.prev();
    } else if (key == 67) { 
      self.thumbnails.toggle();
    } else if (key == 83) { 
      self.sections.toggle();
    } else if (key == 27) { 
      self.slides.show();
    } else {
      return true;
    }
    return false 
  };
};

function Slides(podium_reference) {
  var self = this;
  self.podium = podium_reference;

  self.initialize = function() {
    self.focusFirst();
  };

  self.show = function() {
    self.podium.hideAll();
    $('#slides').show();
  };

  self.focusFirst = function() {
    var hash = window.location.hash;
    var number = 0;
    if (hash != "") { number = hash.split("_")[1]; }
    self.focus($("#slides .slide").eq(number));
  };

  self.focus = function($slide) {
    if ($slide.first().hasClass("slide")) {
      window.location.hash = self.hash($slide);

      $("#slides .slide").removeClass("current");

      $slide.addClass("current");

      self.podium.sections.setCurrent();
      self.podium.thumbnails.setCurrent();
      self.center();
    };
  };

  self.hash = function($slide) {
    return "#slide_" + $("#slides .slide").index($slide);
  };

  self.next = function() {
    if ($("#slides .current .inc:hidden").length > 0) {
      $("#slides .current .inc:hidden").first().show("fast");
    } else {
      self.focus($("#slides .current").next());
    }
  };

  self.prev = function() {
    self.focus($("#slides .current").prev());
  };

  self.center = function() {
    var slide_height = $("#slides .current").height()
    var top = (0.5 * parseFloat($("#slides").height())) - (0.5 * parseFloat(slide_height))
    $("#slides .current").css('padding-top', top)
    $("#slides .current").css('padding-bottom', top)
  };
};

function Thumbnails(podium_reference) {
  var self = this;
  self.podium = podium_reference;

  self.initialize = function() {
    $('<div id="thumbnails"></div>').html($("#slides").html()).appendTo("body");
    $('#thumbnails .slide').hover(function() { $(this).addClass("hover")   }, 
                                  function() { $(this).removeClass("hover")});
    $('#thumbnails .slide').click(function() { 
      self.podium.slides.focus($("#slides .slide").eq($("#thumbnails .slide").index($(this))));
      self.toggle();
    });
    self.toggle();
  };

  self.toggle = function() {
    if ($('#thumbnails').is(':visible')) {
      self.podium.slides.show();
    } else {
      self.podium.hideAll();
      $('#thumbnails').show();
    }
  };

  self.setCurrent = function() {
    $("#thumbnails .slide").removeClass("current");
    $thumb = $("#thumbnails .slide").eq($("#slides .slide").index($("#slides .slide.current")));
    $thumb.addClass("current");
  };
};

function Sections(podium_reference) {
  var self = this;
  self.podium = podium_reference;

  self.initialize = function() {
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
      self.podium.slides.focus($("#slides .slide#" + $(this).attr('rel')));
      self.toggle();
    });

    self.toggle();
  };

  self.toggle = function() {
    if ($('#sections').is(':visible')) {
      self.podium.slides.show();
    } else {
      self.podium.hideAll();
      $('#sections').show();
    }
  };

  self.setCurrent = function() {
    $("#sections .section").removeClass("current");
    $slide = $("#slides .slide.current");
    if ($slide.attr("id")) {
      $section = $("#sections .section[rel='" + $slide.attr("id") + "']");
      $section.addClass("current");
    }
  };
};

function Notes(podium_reference) {
  var self = this;
  self.podium = podium_reference;

  self.initialize = function() {
    // var notes_window = window.open("http://google.com", "podium-notes");
  };
};
