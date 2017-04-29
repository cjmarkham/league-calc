Handlebars.registerHelper('grouped_each', function(every, context, options) {
    var out = "", subcontext = [], i;
    if (context && context.length > 0) {
        for (i = 0; i < context.length; i++) {
            if (i > 0 && i % every === 0) {
                out += options.fn(subcontext);
                subcontext = [];
            }
            subcontext.push(context[i]);
        }
        out += options.fn(subcontext);
    }
    return out;
});

$(function () {
  $('body').on('blur', 'input[name="fixture[home_score]"], input[name="fixture[away_score]"]', function () {
    console.log('blur')
    var element = $(this);
    var score = $(this).val();
    var attr = $(this).attr('name');
    var id = $(this).attr('data-fixture');
    var params = {};
    params[attr] = score;

    var request = $.ajax({
      url: '/fixtures/' + id,
      data: params,
      method: 'PATCH',
      success: function () {
        element.animateHighlight();
      }
    });
  });

  $('.league-table input').on('blur', function () {
    var element = $(this);
    var team = $(this).data('team');
    var attr = $(this).attr('name');

    var params = {};
    params[attr] = $(this).val();

    var request = $.ajax({
      url: '/teams/' + team,
      data: params,
      method: 'PATCH',
      success: function () {
        element.animateHighlight();
      }
    });
  });
});

var notLocked = true;
$.fn.animateHighlight = function(highlightColor, duration) {
    var highlightBg = highlightColor || "rgba(0, 255, 0, .3)";
    var animateMs = duration || 400;
    var originalBg = this.css("backgroundColor");
    if (notLocked) {
        notLocked = false;
        this.stop().animate({backgroundColor: highlightBg}, animateMs).delay(animateMs)
            .animate({backgroundColor: originalBg}, animateMs);
        setTimeout( function() { notLocked = true; }, animateMs);
    }
};
