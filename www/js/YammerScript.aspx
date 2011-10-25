<%@ Page Language="vb" AutoEventWireup="false"  TargetSchema="_http://schemas.microsoft.com/intellisense/ie3-2nav3-0" ContentType="application/x-javascript"%>


var obj;
var test, otherTest, calcDate; ;
var OAuth; if (OAuth == null) OAuth = {};
var AccessToken;

OAuth.setProperties = function setProperties(into, from) {
    if (into != null && from != null) {
        for (var key in from) {
            into[key] = from[key];
        }
    }
    return into;
}

OAuth.setProperties(OAuth, // utility functions
        {
        /** Generate timestamps starting with the given value. */
        correctTimestamp: function correctTimestamp(timestamp) {
            OAuth.timeCorrectionMsec = (timestamp * 1000) - (new Date()).getTime();
        }
            ,
        /** The difference between the correct time and local clock. */
        timeCorrectionMsec: 0
            ,
        timestamp: function timestamp() {
            var t = (new Date()).getTime() + OAuth.timeCorrectionMsec;
            return Math.floor(t / 1000);
        }
            ,
        nonce: function nonce(length) {
            var chars = OAuth.nonce.CHARS;
            var result = "";
            for (var i = 0; i < length; ++i) {
                var rnum = Math.floor(Math.random() * chars.length);
                result += chars.substring(rnum, rnum + 1);
            }
            return result;
        }
    });

OAuth.nonce.CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";

$(document).ready(function () {
    // Retrieve access token
    AccessToken = '<%= Request.QueryString("AccessToken")%>';
    //get messages via XMLHelperService
    var yammerURL = 'http://www.yammer.com/api/v1/messages.json?oauth_version=1.0&access_token=' + AccessToken +  '&callback=?&limit=5';
    
    $.ajax({
        type: "POST",
        data: "{'url':'" + yammerURL + "','expiryInMinutes':'50'}",
        url: "/admin/WebServices/XMLHelperService.asmx/GetXML",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: PopulateResults,
        failure: OnError,
        error: OnError,
        async: false
    });
//    alert(window.id); 
});
//Retrieve user details
function PopulateResults(result) {
    $("#yammerTarget").empty();
    var output = $.parseJSON(result.d);
    //$("#yammerTarget").html(output.messages.length);
    $("#yammerTarget").html('<ul class="socialList"><li>Please wait while my yammer feeds load &nbsp <span class="ajaxSpinner"></span></li></ul>');

    var msg = "";
    var username = "";
    var userUrl = "";
    var avatarUrl = "";
    var socialTime = "";

    var msgAvatar = "";
   
    for (var cnt = 0; cnt < output.messages.length; cnt++) {

        var yammerUserId = output.messages[cnt].sender_id;
        var yammerUserURL = 'http://www.yammer.com/api/v1/users/' + yammerUserId + '.json?oauth_version=1.0&access_token=' + AccessToken;

        username = "";
        userUrl = "";
        avatarUrl = "";
        socialTime = "";

        msgAvatar = "";

        $.ajax({
            type: "POST",
            data: "{'url':'" + yammerUserURL + "','expiryInMinutes':'1000'}",
            url: "/admin/WebServices/XMLHelperService.asmx/GetXML",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (result) {
                var usrObj = $.parseJSON(result.d);

                username = usrObj.full_name;
                userUrl = usrObj.web_url;
                avatarUrl = usrObj.mugshot_url;
                //socialTime = usrObj.timezone;
                //console.log(socialTime);
            },
            failure: OnError,
            error: OnError
        });
       
        msgAvatar = '<a class="socialAvatar" href="' + userUrl + '"><img src="' + avatarUrl + '" height="48" width="48" alt="' + username + '\'s avatar" title="' + username + '\'s avatar" border="0"/></a>';
        msgTime = '<span class="socialTime"><a target= "_blank" href="' + userUrl + '" title="view user on Yammer">by ' + username + '</a></span>';

        if(cnt > 0){
            msg = msg + '<li>' + msgAvatar + '<span class="tweet_text">' + output.messages[cnt].body.plain + '</span>' + msgTime + '</li>';
        } else {
            msg = msg + '<li class="socialFirst">' + msgAvatar + '<span class="tweet_text">' + output.messages[cnt].body.plain + '</span>' + msgTime + '</li>';
        }

    }

    msg = '<ul class="socialList">' + msg + '</ul>';
    
    $("#yammerTarget").html(msg);

    // hide/show items at start
    $('.socialAvatar').hide();
    $('.socialTime').hide();
    $('.socialFirst .socialAvatar').show();
    $('.socialFirst .socialTime').show();
    $('.socialFirst').addClass('opened');

 }

function relativeDate(str) {
    calcDate = str.split("(")[1].split(")")[0];
    calcDate = parseInt(calcDate, 0);
    calcDate = new Date(calcDate);
    return calcDate.toString("d MMM h:mm tt");
}


function OnError(ex) {
    alert('Error: ' + ex._message);
}