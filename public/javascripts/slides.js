$(function() { 
  var podium = new Podium(); 
  podium.initialize();
});

function log(msg) {
  if (typeof(console) != "undefined") {
    console.log(msg);
  };
};

function Podium() {
  var self = this;
  self.initialize = function() {
    self.sections    = new Sections(self);
    self.slides      = new Slides(self);
    self.thumbnails  = new Thumbnails(self);
    self.notes       = new Notes(self);
    self.help        = new Help(self);

    self.sections.initialize();
    self.thumbnails.initialize();
    self.notes.initialize();
    self.slides.initialize();
    self.help.initialize();
    document.onkeydown = new Keyboard(self.commands).keyDown;
    $(window).resize(function() { self.slides.center(); });
  };

  self.commands = {
    next:       function () { self.slides.next() },
    prev:       function () { self.slides.prev() },
    thumbnails: function () { self.thumbnails.toggle() },
    sections:   function () { self.sections.toggle() },
    help:       function () { self.help.toggle() },
    slides:     function () { self.slides.show() },
  };

  self.hideAll = function() {
    $('#thumbnails').hide();
    $('#sections').hide();
    $('#help').hide();
    $('#slides').hide();
  };
};

function Help(podium_reference) {
  var self = this;
  self.podium = podium_reference;

  self.initialize = function() { self.hide(); };

  self.toggle = function() {
    if ($('#help').is(':visible')) {
      self.hide();
    } else {
      self.show();
    };
  };

  self.show = function() { $("#help").fadeIn(); };
  self.hide = function() { $("#help").fadeOut(); };
};

self.Key = function(keyCode) {
  var self = this;
  self.key = keyCode;

  self.is_next = function() {
    return(self.key == 32 || self.key == 34 || self.key == 39 || self.key == 40)
  };
  self.is_prev = function() { 
    return(self.key == 33 || self.key == 37 || self.key == 38)
  };
  self.want_thumbnails = function() { 
    return(self.key == 67)
  };
  self.want_sections = function() { 
    return(self.key == 83)
  };
  self.want_slides = function() { 
    return(self.key == 27)
  };
  self.want_help = function() { 
    return(self.key == 191)
  };
};

function Keyboard(callbacks) {
  var self = this;
  self.commands = callbacks;

  //  See e.g. http://www.quirksmode.org/js/events/keys.html for keycodes
  self.keyDown = function(event) {
    if (event.ctrlKey || event.altKey || event.metaKey)
       return true;

    var key = new Key(event.keyCode);

    if (key.is_next()) {                self.commands.next();
    } else if (key.is_prev()) {         self.commands.prev();
    } else if (key.want_thumbnails()) { self.commands.thumbnails();
    } else if (key.want_sections()) {   self.commands.sections();
    } else if (key.want_slides()) {     self.commands.slides();
    } else if (key.want_help()) {       self.commands.help();
    } else {                            return true;
    }
    return false 
  };
}

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

      $("#slides .slide.current").removeClass("current");
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
    if ($("#slides .current .inc").length > 0) {
      $inc = $("#slides .current .inc").first();
      $inc.removeClass("inc", 200);
    } else {
      self.focus($("#slides .current").next());
    }
  };

  self.prev = function() {
    self.focus($("#slides .current").prev());
  };

  self.center = function() {
    var slide_height = $("#slides .current").height();
    var window_height = parseFloat($(window).height());
    var window_width  = parseFloat($(window).width());
    var vertical_padding = (0.5 * window_height) - (0.5 * parseFloat(slide_height));

    $("#slides").css("height", window_height);
    $("#slides").css("width",  window_width);
    $("#slides .current").css('padding-top',    vertical_padding);
    $("#slides .current").css('padding-bottom', vertical_padding);
  };
};

function Thumbnails(podium_reference) {
  var self = this;
  self.podium = podium_reference;

  self.initialize = function() {
    $('<div id="thumbnails"></div>').html($("#slides").html()).appendTo("body");
    $('#thumbnails .slide').click(function() { 
      self.toggle();
      self.podium.slides.focus($("#slides .slide").eq($("#thumbnails .slide").index($(this))));
    });
    self.toggle();
  };

  self.toggle = function() {
    if ($('#thumbnails').is(':visible')) {
      self.podium.slides.show();
    } else {
      self.podium.hideAll();
      $('#thumbnails').show();
      $(window).scrollTop($("#thumbnails .slide.current").offset().top - 100);
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
    $('<div id="sections"></div>').appendTo("body");
    $("<ul/>", {"id": "section_list"}).appendTo("#sections");

    $("#slides .slide.section[id]").each(function(){ 
      var id = $(this).attr("id");
      var human = String(id).replace(/_/g, ' ');

      var $section_list_item = $("<li/>", {"class": "section", rel: id, text: human});
      $section_list_item.appendTo("#section_list");

      $subsections = $(this).nextUntil(".section").filter(".subsection");
      if ($subsections.first) {
        var $subsection_list = $("<ul/>");
        $subsection_list.appendTo($("#section_list"));
        $subsections.each(function(){ 
          var subsection_slide_id = $(this).attr("id");
          var subsection_human = String(subsection_slide_id).replace(/_/g, ' ');

          var $subsection_list_item = $("<li/>", {"class": "subsection", 
                                                  rel: subsection_slide_id, 
                                                  text: subsection_human});
          $subsection_list_item.appendTo($subsection_list);
        });
      };
    });

    $('#sections li[rel]').click(function() { 
      self.toggle();
      self.podium.slides.focus($("#slides .slide#" + $(this).attr('rel')));
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
