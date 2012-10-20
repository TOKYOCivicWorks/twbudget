dailybread = function () {
    var os_path = '/openspendingjs';

    var db_load_data = function load_data(db, data) {
      $('#content-wrap').show();
      $('#preloader').remove();
      
      db.setDataFromAggregator(data, ['unknown']);
      db.setIconLookup(function(name) {
        var style = OpenSpending.Styles.Cofog[name];
        if (style != undefined) {
         return style['icon'];
        }
        return 'icons/unknown.svg';
      });
      db.draw();
    } 

    var db_init = function db_init() {
      $('#preloader .txt').html('loading data');
      
      var db = new OpenSpending.DailyBread($('#dailybread'));   

      new OpenSpending.Aggregator({
        apiUrl: 'http://openspending.org/api',
        dataset: 'twbudget',
        drilldowns: ['cat', 'depcat', 'name'],
        cuts: ['year:2012'],
        rootNodeLabel: 'Total', 
        breakdown: 'topname',
        callback: function (data) { db_load_data(db, data); }
      });
    }

    yepnope({
      load: [
        // 'http://wheredoesmymoneygo.org/wp-content/themes/wdmmg/wdmmg.css',
        'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/themes/ui-lightness/jquery-ui.css',
        'http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js',
        'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js',
        os_path + '/lib/vendor/base64.js',
        os_path + '/lib/vendor/underscore.js',
        os_path + '/lib/vendor/raphael-min.js',
        os_path + '/lib/aggregator.js',
        os_path + '/app/dailybread/css/dailybread.css',
        os_path + '/app/dailybread/js/cofog.js',
        os_path + '/app/dailybread/js/dailybread.js'
      ],
      complete: function () { jQuery(function ($) { db_init() } ); }
    });

}

