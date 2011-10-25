<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Yammer2Component.aspx.vb" Inherits="_SNAP.Yammer2Component" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head id="Head1" runat="server">
    <title>Facebook Feed</title>
    <link href="includes/styles.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/styles.css" />
    
  </head>
<body>
    <form id="form1" runat="server">
        <div>
            <!-- Display View -->
     
		    <asp:PlaceHolder ID="DisplayMode" runat="server">
                   <script type="text/javascript" src="https://assets.yammer.com/platform/yam.js"></script>
                               <script type="text/javascript">                        yam.config({ appId: "4464" });  
                   </script>
              
                   <div id="yam">
               asdasdas
                    <script type="text/javascript">

                        yam.getLoginStatus(function (response) {
                            if (response.authResponse) {
                                alert("in and connected user, someone you know");
                            } else {
                                yam.login(function (response) {
                                    if (response.authResponse) {
                                        // user successfully logged in
                                    } else {
                                        // user cancelled login
                                    }
                                });
                            }
                           });     
                        
                    </script>
                </div>
                
               
            </asp:PlaceHolder>
		
		    <!-- Edit View -->
		    <asp:PlaceHolder ID="EditMode" runat="server">
               
		    </asp:PlaceHolder>
        </div>
    </form>

   
</body>
</html>
