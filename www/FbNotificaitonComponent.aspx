<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FbNotificaitonComponent.aspx.vb" Inherits="_SNAP.FbNotificaitonComponent" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head runat="server">
    <title>FB API</title>

    <style type="text/css">
			body {margin:0;padding:0;width:100%;height:100%;font-family: Helvetica Neue, Helvetica, Arial sans-serif;}
			.buttonHolder {padding:30px;width:500px;}
			.searchHolder {padding:30px 0;}
			h3 {margin-top:0;}
			.button {
				font-family: Helvetica Neue, Helvetica, Arial sans-serif;
				font-weight:bold;
				font-size: 14px;
				color: #ffffff;
				padding: 4px 10px;
				background: -moz-linear-gradient(
					top,
					#cfcfcf 0%,
					#949494 25%,
					#6b6b6b 75%,
					#5c5c5c);
				background: -webkit-gradient(
					linear, left top, left bottom, 
					from(#cfcfcf),
					color-stop(0.25, #949494),
					color-stop(0.75, #6b6b6b),
					to(#5c5c5c));
				border-radius: 6px;
				-moz-border-radius: 6px;
				-webkit-border-radius: 6px;
				border: 1px solid #4f4f4f;
				-moz-box-shadow:
					0px 1px 3px rgba(000,000,000,0.5),
					inset 0px 0px 10px rgba(087,087,087,0.7);
				-webkit-box-shadow:
					0px 1px 3px rgba(000,000,000,0.5),
					inset 0px 0px 10px rgba(087,087,087,0.7);
				text-shadow:
					0px -1px 0px rgba(000,000,000,0.6);
				display:inline-block;
				cursor:pointer;
			}
			.searchItem {background-color:#efefef;border-bottom:dashed 1px #DDDDDD;padding:0 6px 0 56px;height:50px;}
			#searchItemClone {display:none;}
			.userName {padding:6px 0;}
			.hr {padding:30px 0 0 0;margin:30px 0 0 0;width:100%;border-top:dashed 1px #DDDDDD;}
		</style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!-- Display View -->
		    <asp:PlaceHolder ID="DisplayMode" runat="server">
            <div id="fb-root">
                    </div>
                    <div id="fb_message">
                    </div>
                   
                    <script type="text/javascript">

                        var application_id = 223569377685958;
                        var application_name = 'apiinstall';

                        if (!(application_id)) {
                            alert(application_id);
                            document.getElementById('fb_message').style.display = "block";
                            document.getElementById('fb_message').innerHTML = "Facebook application_id not defined.";
                        } else if (!(application_name)) {
                            document.getElementById('fb_message').style.display = "block";
                            document.getElementById('fb_message').innerHTML = "Facebook application_name not defined.";
                        } else {
                            document.getElementById('fb_message').innerHTML = "";
                            document.getElementById('fb_message').style.display = "none";
                        }

                        var news_results;
                        var friends_results;
                        var notification_results;
                        var friend_request_results;

                        window.fbAsyncInit = function () {
                            FB.init({
                                appId: 223569377685958,
                                status: true,
                                cookie: true,
                                xfbml: true
                            });

                            /* All the events registered */
                            FB.Event.subscribe('auth.login', function (response) {
                                // reload the page so news will show
                                //window.location.reload();
                            });
                            FB.Event.subscribe('auth.logout', function (response) {
                                document.getElementById('fb_status').style.display = "none";
                                document.getElementById('fb_news').style.display = "none";
                                document.getElementById('fb_dashboard').style.display = "none";
                            });

                            FB.getLoginStatus(function (response) {
                                if (response.session) {
                                    document.getElementById('fb_news').style.display = "block";
                                    document.getElementById('fb_news').innerHTML = "Asking Facebook for latest news from your friends...";
                                    var q1 = FB.Data.query("SELECT created_time, actor_id, message, permalink FROM stream WHERE source_id in (SELECT target_id FROM connection WHERE source_id=me() AND is_following=1) AND strlen(message) > 0 AND is_hidden = 0 limit 5");
                                    document.getElementById('fb_news').innerHTML = "Asking Facebook for name and pictures of friends with news...";
                                    var q2 = FB.Data.query("SELECT uid, pic_square, name FROM user WHERE uid IN (SELECT actor_id FROM stream WHERE source_id in (SELECT target_id FROM connection WHERE source_id=me() AND is_following=1) AND strlen(message) > 0 AND is_hidden = 0 limit 5)");
                                    document.getElementById('fb_news').innerHTML = "Asking Facebook for number of notifications...";
                                    var q3 = FB.Data.query("SELECT notification_id FROM notification WHERE recipient_id=me() AND is_hidden = 0");
                                    document.getElementById('fb_news').innerHTML = "Asking Facebook for number of friend requests...";
                                    var q4 = FB.Data.query("SELECT uid_from FROM friend_request WHERE uid_to=me()");
                                    document.getElementById('fb_news').innerHTML = "Waiting on Facebook...";
                                    alert('1');
                                    FB.Data.waitOn([q1, q2, q3, q4], function (args) {
                                        alert('1a');
                                        document.getElementById('fb_news').innerHTML = "Processing Facebook data...";
                                        news_results = args[0];
                                        friends_results = args[1];
                                        notification_results = args[2];
                                        friend_request_results = args[3];
                                        displayFacebookData();
                                        document.getElementById('fb_dashboard').style.display = "block";
                                        document.getElementById('fb_status').style.display = "block";
                                    });
                                }
                            });

                            FB.XFBML.parse();
                        };
                        (function () {
                            var e = document.createElement('script');
                            e.type = 'text/javascript';
                            e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
                            e.async = true;
                            document.getElementById('fb-root').appendChild(e);
                        } ());

                        function displayFacebookData() {
                            alert('2');
                            document.getElementById('fb_dashboard').innerHTML = "<table>\n<tbody>\n<tr>\n";
                            document.getElementById('fb_news').innerHTML = "Displaying Facebook notifications...";
                            if (notification_results != null) {
                                document.getElementById('fb_dashboard').innerHTML += "<td><a href='http://www.facebook.com/'>Notifications: " + notification_results.length + "</a></td>\n";
                            }
                            else {
                                document.getElementById('fb_dashboard').innerHTML += "<td><a href='http://www.facebook.com/'>Notifications: None</a></td>\n";
                            }
                            document.getElementById('fb_news').innerHTML = "Displaying Facebook friend requests...";

                            if (friend_request_results != null) {
                                document.getElementById('fb_dashboard').innerHTML += "<td><a href='http://www.facebook.com/friends/edit/?sk=requests'>Friend Requests: " + friend_request_results.length + "</a></td>\n";
                            }
                            else {
                                document.getElementById('fb_dashboard').innerHTML += "<td><a href='http://www.facebook.com/friends/edit/?sk=requests'>Friend Requests: None</a></td>\n";
                            }
                            document.getElementById('fb_dashboard').innerHTML += "</tr>\n</td>\n</tbody>\n</table>\n";
                            document.getElementById('fb_news').innerHTML = "Done preparing Facebook dashboard. Displaying news from friends: " + news_results.length + " news items from " + friends_results.length + " users...";

                            if (!(friends_results.length > 0)) {
                                document.getElementById('fb_news').innerHTML = 'No news from friends. <a href="#" onclick="window.location.reload();">Click here to refresh.</a>';
                            }
                            else {
                                try {
                                    var tableHtml = "";
                                    tableHtml = '\n<table style="width:100%;">\n  <tbody>\n';

                                    var uidToFriendResult = new Object();
                                    for (i = 0; i < friends_results.length; i++) {
                                        uidToFriendResult[friends_results[i].uid] = friends_results[i];
                                    }
                                    for (i = 0; i < news_results.length; i++) {
                                        if (i % 2 == 0) {
                                            rowClass = 'fb_normal';
                                        } else {
                                            rowClass = 'fb_alternate';
                                        }

                                        var friendImageUrl = "img/unknown.gif";
                                        var friendName = "Unknown";
                                        var friendResult = uidToFriendResult[news_results[i].actor_id];
                                        if (friendResult != null) {
                                            if (friendResult.pic_square != null) {
                                                friendImageUrl = friendResult.pic_square;
                                            }

                                            if (friendResult.name != null) {
                                                friendName = friendResult.name;
                                            }
                                        }

                                        var msg = "";
                                        var date = "";
                                        var postUrl = "http://www.facebook.com/?ref=home#permalink-for-post-was-not-supplied-by-facebook";
                                        if (news_results != null && news_results[i] != null) {
                                            if (news_results[i].permalink != null) {
                                                postUrl = news_results[i].permalink;
                                            }

                                            msg = news_results[i].message;
                                            if (msg == null) {
                                                msg = "";
                                            } else if (msg.length > 160) {
                                                msg = msg.substring(0, 160) + "... (more)";
                                            }

                                            if (news_results[i].created_time != null && news_results[i].created_time > 0) {
                                                var d = new Date();
                                                d.setTime(news_results[i].created_time * 1000);
                                                var year = d.getFullYear().toString().slice(2);
                                                var month = d.getMonth() + 1;
                                                if (month < 10) { month = "0" + month; }
                                                var date = d.getDate();
                                                if (date < 10) { date = "0" + date; }
                                                var hour = d.getHours();
                                                var ampm = "am";
                                                if (hour > 11) { ampm = "pm"; }
                                                if (hour > 12) { hour = hour - 12; }
                                                if (hour == 0) { hour = 12; }
                                                if (hour < 10) { hour = "0" + hour; }
                                                var minutes = d.getMinutes();
                                                if (minutes < 10) { minutes = "0" + minutes; }
                                                date = month + "/" + date + "/" + year + " " + hour + ":" + minutes + ampm;
                                            }
                                        }
                                        tableHtml += "    <tr class='";
                                        tableHtml += rowClass;
                                        tableHtml += "'>\n      <td><a href='" + postUrl + "' target='_blank'><img src='";
                                        tableHtml += friendImageUrl;
                                        tableHtml += "' alt='";
                                        tableHtml += friendName;
                                        tableHtml += "' title='";
                                        tableHtml += friendName;
                                        tableHtml += "' style='width:auto; height:20px;'/></a></td>\n      <td><a href='" + postUrl + "' target='_blank'>";
                                        tableHtml += friendName;
                                        tableHtml += "</a></td>\n      <td><a href='" + postUrl + "' target='_blank'>";
                                        tableHtml += msg;
                                        tableHtml += "</a></td>\n      <td><span style='white-space: nowrap;'><a href='" + postUrl + "' target='_blank'>";
                                        tableHtml += date;
                                        tableHtml += "</a></span></td></tr>\n";
                                    }
                                    tableHtml += '  </tbody>\n</table>\n';

                                    document.getElementById('fb_news').innerHTML = tableHtml;
                                } catch (e) {
                                    var errorMsg = '';
                                    for (var property in e) {
                                        errorMsg += property + ': ' + e[property] + '\r\n';
                                    }
                                    document.getElementById('fb_news').innerHTML = "<pre>" + errorMsg + "</pre>";
                                }
                            }
                        }

                        function setStatus() {
                            status1 = document.getElementById('fb_status_text').value;
                            FB.api({
                                method: 'status.set',
                                status: status1
                            }, function (response) {
                                if (response == 0) {
                                    alert('Your Facebook status was not updated. In your Facebook profile\'s privacy settings, remove ' + my_facebook_application + ' from your privacy settings, go back to this page, login, and agree to give the application the required privacy settings.');
                                } else {
                                    alert('Your Facebook status was updated');
                                }
                            });
                        }
                    </script>
                    <p>
                        <fb:login-button autologoutlink="true" perms="status_update,publish_stream,read_stream,offline_access">
                        </fb:login-button>
                    </p>
                    <div id="fb_dashboard">
                    </div>
                    <div id="fb_news">
                    <a href="#" onclick="window.location.reload();">Click here to refresh news</a>
                    </div>
                    <div id="fb_status">
                    <textarea id="fb_status_text" cols="50" rows="2" placeholder="Post status to Facebook">
                    </textarea>
                    <br />
                    <input type="button" value="Post Status to Facebook" onclick="setStatus(); return false;"/>
                    </div>
                
            </asp:PlaceHolder>
		
		    <!-- Edit View -->
		    <asp:PlaceHolder ID="EditMode" runat="server">
               
		    </asp:PlaceHolder>
        </div>
    </form>
</body>
</html>
