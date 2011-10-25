<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FacebookComponent.aspx.vb" Inherits="_SNAP.FacebookComponent" %>

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
            <div id="fb-root"></div> 
                <script type="text/javascript">
                                
                    var redirectURL = "http://apiinstall/home/TJTWITTER/FBtest.html";
                    var clientID = "223569377685958";
                    var clientSecret = "1c79a10ec60a6787c6073cc2fd892e0b";
                    var url = "https://graph.facebook.com/oauth/access_token?client_id=" + clientID + "&redirect_uri=" + redirectURL + "&client_secret=" + clientSecret;

                    window.fbAsyncInit = function () {
                       
                           FB.init({ appId: clientID, status: true, cookie: true, xfbml: true });

                            FB.Event.subscribe('auth.login', function (response) {
                                
                                login();
                            });
                            FB.Event.subscribe('auth.logout', function (response) {
                                
                                logout();
                            });

                            FB.getLoginStatus(function (response) {
                                if (response.session) {
                                    // logged in 
                                    login();
                                }
                            });
                        };

                        (function () {
                            var e = document.createElement('script');
                            e.type = 'text/javascript';
                            e.src = document.location.protocol +
                                '//connect.facebook.net/en_US/all.js';
                            e.async = true;
                            document.getElementById('fb-root').appendChild(e);
                        } ());

                        function login() {
                            FB.api('/me', function (response) {
                                document.getElementById('login').style.display = "block";
                                console.log(response);
                                document.getElementById('login').innerHTML = "<img src='https://graph.facebook.com/" + response.id + "/picture?type=small'>&nbsp;" + response.name + 
                                " Successfully logged in!";
                            });
                        }

                        function DisplayName() {
                            FB.api('/me/feed', 'post', { message: 'Hello FB' }, function (response) {
                                if (!response || response.error) {
                                    alert('Data not published');
                                } else {
                                    alert('Message posted')
                                }
                              });
                        }
            
                        function logout() {
                            document.getElementById('login').style.display = "none";
                        }

                        //stream publish method
                        function streamPublish(name, description, hrefTitle, hrefLink, userPrompt) {
                            FB.ui(
                            {
                                method: 'stream.publish',
                                message: '',
                                attachment: {
                                    name: name,
                                    caption: '',
                                    description: (description),
                                    href: hrefLink
                                },
                                action_links: [
                                    { text: hrefTitle, href: hrefLink }
                                ],
                                user_prompt_message: userPrompt
                            },
                            function (response) {

                            });

                        }
                        function showStream() {
                            FB.api('/me', function (response) {
                                //console.log(response.id);
                                streamPublish(response.name, 'Test', 'hrefTitle', 'http://www.adweb.com.au/', "Share Adweb");
                            });
                        }

//                        function share() {
//                            var share = {
//                                method: 'stream.share',
//                                u: 'http://www.adweb.com.au/'
//                            };

//                            FB.ui(share, function (response) { console.log(response); });
//                        }

                        function graphStreamPublish() {
                            var body = 'Graph api & Javascript Base FBConnect';
                            FB.api('/me/feed', 'post', { message: body }, function (response) {
                                if (!response || response.error) {
                                    alert('Error occured');
                                } else {
                                    alert('Post ID: ' + response.id);
                                }
                            });
                        }

                        function groupNews() {
                            var body = 'GroupNews';
                            FB.api( '/me/feed', function (response) {
                                if (!response || response.error) {
                                    alert('Error occured');
                                } else {
                                    alert('Post ID: ' + response.name);
                                }
                            });
                        }
                        //563149504

                        //// 
                        function fqlQuery() {
                            FB.api('/me', function (response) {
                                var query = FB.Data.query('select name, hometown_location, sex, pic_square from user where uid={0}', response.id);
                                query.wait(function (rows) {
                                    alert('1');
                                    for (i = 0; i < rows.length; i++) {
                                        document.getElementById('name').innerHTML =
                                     'Your name: ' + rows[i].name + "<br />" +
                                     '<img src="' + rows[i].pic_square + '" alt="" />' + "<br />";
                                    }
                                });
                            });
                        }

                      
                        //test
                        function searchForUser() {
                            var searchText = $("#facebookSearch").val();
                            $(".searchResults").html("<h3>Loading Results...</h3>");
                            
                            FB.api("/search?q=" + searchText + "&type=user", function (response) {
                                if ($(response.data).length !== 1) {
                                    $(".searchResults h3").html($(response.data).length + " People found");
                                }
                                else {
                                    $(".searchResults h3").html($(response.data).length + " Person found");
                                }
                                $(response.data).each(function (key, item) {
                                    //console.log(item);
                                    $("#searchItemClone").clone()
							.attr("id", "row" + key)
							.css("background", "#efefef url(https://graph.facebook.com/" + item.id + "/picture?type=small) no-repeat 0 0")
							.children(".userName").html(item.name).end()
							.appendTo(".searchResults");
                                });
                            });
                        }
				
			
            //                    var query = FB.Data.query('SELECT recent_news FROM group WHERE gid  = 14128862899', response.id);
            
                        function setStatus() {
                            status1 = document.getElementById('status').value;
                            FB.api(
                              {
                                  method: 'status.set',
                                  status: status1
                              },
                              function (response) {
                                  if (response == 0) {
                                      alert('Please give Status Update Permission.');
                                  }
                                  else {
                                      alert('Your facebook status updated');
                                  }
                              }
                            );
                        }
        </script> 
 
        <p><fb:login-button autologoutlink="true" perms="email,user_birthday,status_update,publish_stream,user_about_me"></fb:login-button></p> 
        <div id="login"></div>
        <div id="logout"></div>
        <p> 
            <a href="#" onclick="showStream(); return false;">Publish Wall Post</a> |
            <%--<a href="#" onclick="share(); return false;">Share With Your Friends</a> |--%>
            <a href="#" onclick="graphStreamPublish(); return false;">Publish Stream Using Graph API</a> |
            <a href="#" onclick="DisplayName(); return false;">Display Name</a> |
            <a href="#" onclick="fqlQuery(); return false;">FQL Query Example</a> |
            <a href="#" onclick="setStatus(); return false;">Status Set via Legacy Api Call</a> 
 
        </p> 
 
        <textarea id="status" cols="50" rows="5">Write your status here and click 'Status Set Using Legacy Api Call'</textarea> 
        <br /> 
        
        <br /><br /><br /> 
        

        <div id="name"></div>
                
                <div class="searchHolder">
					Search Facebook: <input type="text" id="facebookSearch" /> 
                   <input type="button" onclick="searchForUser(); return false;" id="submitSearch" value="Search" class="button" />
				</div>
				
				<div class="searchResults">
					<h3></h3>
					
				</div>
                	<div id="searchItemClone" class="searchItem">
					<div class="userName"></div>
				</div>
                   
                
            </asp:PlaceHolder>
		
		    <!-- Edit View -->
		    <asp:PlaceHolder ID="EditMode" runat="server">
               
		    </asp:PlaceHolder>
        </div>
    </form>
</body>
</html>
