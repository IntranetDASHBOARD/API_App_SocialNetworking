<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="component.aspx.vb" Inherits="_SNAP.component" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>TWITTER API</title>
     <% Response.Write("<link href=""" + Intranet.CurrentSubsiteThemePath + """ type=""text/css"" rel=""stylesheet"">")%>
	<link href="../includes/styles.css" type="text/css" rel="stylesheet" />
    <link href="/includes/css/api_styleReset.aspx" type="text/css" rel="Stylesheet" />
    <script src="http://twitterjs.googlecode.com/svn/trunk/src/twitter.min.js"></script>

    </head>
<body>
    <form id="form1" runat="server">
        <div>
            <!-- Display View -->
		    <asp:PlaceHolder ID="DisplayMode" runat="server">
                <div id="welcome">
                <p> Twitter updates of <%= GetExternalComponentPropertyValue("userName")%>
                
                </p> 
                </div> 

			    <div id="tweet">
                 <p>Please wait while my tweets load <img src="/images/indicator.gif" /></p> 
                    <script type="text/javascript" charset="utf-8">
                      getTwitters('tweet', {
                          id: '<%= GetExternalComponentPropertyValue("userName")%>',
                          count: '<%= GetExternalComponentPropertyValue("tweetCount")%>',
                            enableLinks: true,
                            ignoreReplies: true,
                            clearContents: true,
                            template: '"%text%" <a href="http://twitter.com/%user_screen_name%/statuses/%id_str%/">%time%</a>'
                        });
                    </script>
                <p><a href="http://twitter.com/<%= GetExternalComponentPropertyValue("Username")%>">Twitter link to the feed</a></p>
                </div>
		    </asp:PlaceHolder>
		
		    <!-- Edit View -->
		    <asp:PlaceHolder ID="EditMode" runat="server">
              
		    </asp:PlaceHolder>
        </div>
    </form>
</body>
</html>
