var obj;
var test, otherTest, calcDate; ;
var OAuth; if (OAuth == null) OAuth = {};

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
        /** The difference between the correct time and my clock. */
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
    //get messages
    var yammerURL = "http://www.yammer.com/api/v1/messages.json?oauth_version=1.0&access_token=wKq2AWPGjvdbmi8Qf35OuQ&callback=?&limit=10"
    
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

function PopulateResults(result) {
    $("#yammerTarget").empty();
    var output = $.parseJSON(result.d);
    $("#yammerTarget").html(output.messages.length);
    var msg = "";
    var username = "";
    //        var imagePath = "";
   
    for (var cnt = 0; cnt < output.messages.length; cnt++) {

        var yammerUserId = output.messages[cnt].sender_id;
        var yammerUserURL = "http://www.yammer.com/api/v1/users/" + yammerUserId + ".json?oauth_version=1.0&access_token=wKq2AWPGjvdbmi8Qf35OuQ"

        username = "";
        // imagePath = "";

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
                imagePath = usrObj.mugshot_url;
            },
            failure: OnError,
            error: OnError
        });
        //debugger;
        //msg = "<img src=" + imagePath + "/>"; 
        msg = msg + username + ": " + output.messages[cnt].body.plain + "</br>";

    }
  // msg = msg + ("<a />").text("View More").addClass("viewMoreTwitter").attr("href", "https://www.yammer.com/adweb.com.au/").attr("target", "_blank");

   // msg = msg + "<a href=" + "https://www.yammer.com/adweb.com.au/>";
    $("#yammerTarget").html(msg);
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