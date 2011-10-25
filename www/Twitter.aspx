<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Twitter.aspx.vb" Inherits="_SocialNetworking.Twitter" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title>TWITTER API</title>
    <% Response.Write("<link href=""" + Intranet.CurrentSubsiteThemePath + """ type=""text/css"" rel=""stylesheet"">")%>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
    <script language="javascript" src="js/jquery.tweet.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
            
            <!--[if !IE]>-----// Display View //-----<![endif]-->
		    <asp:PlaceHolder ID="DisplayMode" runat="server">
                
                <div class="Content tableMain">
                    <div id="Welcome" class="welcome">Twitter updates of <%=GetExternalComponentPropertyValue("UserName")%></div>
			        <div id="Tweet"></div>
                
                    <div class="appFoot">
                        Visit <a href="http://twitter.com/<%= GetExternalComponentPropertyValue("UserName")%>"><%= GetExternalComponentPropertyValue("UserName")%></a> @ Twitter
                    </div>

                    <!--[if !IE]>-----// Twitter function call //-----<![endif]-->
                    <script type="text/javascript" charset="utf-8">
                        jQuery(function ($) {

                            $("#Tweet").tweet({
                                username: '<%= GetExternalComponentPropertyValue("UserName")%>',
                                count: '<%= GetExternalComponentPropertyValue("TweetCount")%>',
                                loading_text: '<ul class="socialList"><li>Please wait while tweets load &nbsp <span class="ajaxSpinner"></span></li></ul>'
                            });

                            $(".socialList li").live('click', function () {
                                var avatarItem = $(this).find('.socialAvatar');
                                var timeItem = $(this).find('.socialTime');

                                //reset iframe height
                                if (jQuery.browser.msie !== true) {
                                    var currentIframe = $(parent.document).contents().find("iframe");
                                    currentIframe.height('auto');
                                }

                                if ($(this).hasClass('opened')) {
                                    avatarItem.hide();
                                    timeItem.hide();
                                    $(this).removeClass('opened');
                                } else {

                                    avatarItem.show();
                                    timeItem.show(400);
                                    $(this).addClass('opened');
                                }
                            });

                            $(".welcome")
				            .wrap('<div class="ribbon"><div class="bd"><div class="c"><div class="s"></div></div></div></div>');

                        });
                    </script>
                
                </div><!--[if !IE]>-----// end of Content tableMain //-----<![endif]-->

		    </asp:PlaceHolder>
		    
            <!--[if !IE]>-----// Edit View //-----<![endif]-->
		    <asp:PlaceHolder ID="EditMode" runat="server"></asp:PlaceHolder>


    </form>
</body>
</html>
