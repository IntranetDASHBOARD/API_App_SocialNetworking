<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Yammer.aspx.vb" Inherits="_SocialNetworking.Yammer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title>Yammer Component</title>
    <% Response.Write("<link href=""" + Intranet.CurrentSubsiteThemePath + """ type=""text/css"" rel=""stylesheet"">")%>
	<link rel="stylesheet" type="text/css" href="css/style.css" />
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        
        <!--[if !IE]>-----// Display View //-----<![endif]-->
		<asp:PlaceHolder ID="DisplayMode" runat="server">    
            
            <div class="Content tableMain">
                
                <div class="welcome">Yammer Updates</div>             
                <div id="yammerTarget">
                    <ul class="socialList"><li>Please wait while my yammer feeds load &nbsp <span class="ajaxSpinner"></span></li></ul>
                </div><!--[if !IE]>-----// end of yammerTarget //-----<![endif]-->
                
                <div class="appFoot">
                 <a target="_blank" href="https://www.yammer.com/<%= GetExternalComponentPropertyValue("GroupName")%>">Visit us @ Yammer</a>
                </div>

                <script type="text/javascript" charset="utf-8">
                    jQuery(function ($) {

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

                                var currentIframe = $(parent.document).find("iframe").contents().has(this);
                                console.log(currentIframe);
                                currentIframe.height(800);
                                console.log(currentIframe.height());

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