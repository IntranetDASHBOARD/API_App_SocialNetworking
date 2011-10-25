
(function($){
	
	$.fn.facebookWall = function(options){
		
		options = options || {};
		
		if(!options.id){
			throw new Error('You need to provide an user/page id!');
		}
		
		if(!options.access_token){
			throw new Error('You need to provide an access token!');
		}
		
		// Default options of plugin:
		
		options = $.extend({
			limit: 4	// Set number of posts here.
		},options);

		// Putting together the Facebook Graph API URLs:

		var graphUSER = 'https://graph.facebook.com/'+options.id+'/?fields=name,picture&access_token='+options.access_token+'&callback=?',
			graphPOSTS = 'https://graph.facebook.com/'+options.id+'/posts/?access_token='+options.access_token+'&callback=?&date_format=U&limit='+options.limit;
		
		var wall = this;
		
		$.when($.getJSON(graphUSER),$.getJSON(graphPOSTS)).done(function(user,posts){
			
			// user[0] contains information about the user (name and picture);
			// posts[0].data is an array with wall posts;
			
			var fb = {
				user : user[0],
				posts : []
			};

			$.each(posts[0].data,function(){
				
				// Set type of feed:
				if((this.type != 'link' && this.type!='status' && this.type!='photo') || !this.message){
					return true;
				}

				// Copying the user avatar to each post for templates
				
				this.from.picture = fb.user.picture;
				
				// Converting the created_time (a UNIX timestamp) to
				// a relative time offset (e.g. 5 minutes ago):
				this.created_time = relativeTime(this.created_time*1000);
				
				// Converting URL strings to actual hyperlinks:
				this.message = urlHyperlinks(this.message);

				fb.posts.push(this);
			});

			// Rendering the templates:
			$('#headingTpl').tmpl(fb.user).appendTo(wall);
			
			// Creating an unordered list for the posts:
			var ul = $('<ul>').appendTo(wall);
			
			// Generating the feed template and appending:
			$('#feedTpl').tmpl(fb.posts).appendTo(ul);
		});
		
		return this;

	};

	// Helper functions:

	function urlHyperlinks(str){
		return str.replace(/\b((http|https):\/\/\S+)/g,'<a href="$1" target="_blank">$1</a>');
	}

	function relativeTime(time){
		
		// Adapted from James Herdman's http://bit.ly/e5Jnxe
		
		var period = new Date(time);
		var delta = new Date() - period;

		if (delta <= 10000) {	// Less than 10 seconds ago
			return 'Just now';
		}
		
		var units = null;
		
		var conversions = {
			millisecond: 1,		// ms -> ms
			second: 1000,		// ms -> sec
			minute: 60,			// sec -> min
			hour: 60,			// min -> hour
			day: 24,			// hour -> day
			month: 30,			// day -> month (roughly)
			year: 12			// month -> year
		};
		
		for (var key in conversions) {
			if (delta < conversions[key]) {
				break;
			}
			else {
				units = key;
				delta = delta / conversions[key];
			}
		}
		
		// Pluralize if necessary:
		
		delta = Math.floor(delta);
		if (delta !== 1) { units += 's'; }
		return [delta, units, "ago"].join(' ');
		
	}

})(jQuery);


$(document).ready(function () {

    console.log('hi u came here');
    // Plugin
    $('#wall').facebookWall({
        id: 'teachforindia',
        access_token: '223569377685958|QDoMEirxxHD8FKx9sT7-sW8k9Og'
    });

});

