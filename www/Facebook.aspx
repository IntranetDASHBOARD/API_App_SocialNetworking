<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Facebook.aspx.vb" Inherits="_SocialNetworking.Facebook" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head id="Head1" runat="server">

    <title>Facebook Feed</title>

    <% Response.Write("<link href=""" + Intranet.CurrentSubsiteThemePath + """ type=""text/css"" rel=""stylesheet"">")%>
	<link rel="stylesheet" type="text/css" href="css/style.css" />
    
  </head>
<body>
    <form id="Form1" runat="server">

        <!--[if !IE]>-----// Display View //-----<![endif]-->
        <asp:PlaceHolder ID="DisplayMode" runat="server">
            
            <div class="Content tableMain">
                    
                    <div id="Page">
	                   <div id="wall" class="facebookWall"></div>
                    </div>
                    
                    <!--[if !IE]>-----// Facebook Head Template //-----<![endif]-->  
                    <script id="headingTemplate" type="text/x-jquery-tmpl">
                        <div class="welcome">${name} on Facebook</div>
                    </script>      

                    <!--[if !IE]>-----// Facebook Feed Template //-----<![endif]--> 
                    <script id="feedTemplate" type="text/x-jquery-tmpl">
                    <li>
	                    <table cellpadding="0" cellspacing="0" border="0" class="socialTable">
                            <tr>
                                <td width="53" valign="top" class="socialAvatarTd"> 
                                    <a href="http://www.facebook.com/profile.php?id=${from.id}" class="socialAvatar" target="_parent"><img src="${from.picture}" class="avatar" /></a>
	                            </td>
                                <td valign="top">
	                                
                                    {{html message}}

                                    <div class="extra">

                                        ${created_time} · 
	                                    {{if comments}}
		                                    ${comments.count} Comment{{if comments.count>1}}s{{/if}}
	                                    {{else}}
		                                    0 Comments
	                                    {{/if}} · 
	                                    {{if likes}}
		                                    ${likes.count} Like{{if likes.count>1}}s{{/if}}
	                                    {{else}}
		                                    0 Likes
	                                    {{/if}}

		                                {{if type == "link" }}
			                                <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
				                                    {{if picture}}
                                                    <td width="77" valign="top" class="attachment"> 
					                                    <img class="picture" src="${picture}" width="72" height="72" />
                                                    </td>
				                                    {{/if}}
				                                    <td class="attachment-data" valign="top">
					                                    <span class="name"><a href="${link}" target="_parent">${name}</a></span><br />
					                                    <span class="caption">${caption}</span><br />
					                                    <span class="description">${description}</span>
				                                    </td>
                                                </tr>
			                                </table>
		                                {{/if}}

                                    </div><!--[if !IE]>-----// end of extra //-----<![endif]-->    

                                    <div class="socialTime"><a href="http://www.facebook.com/profile.php?id=${from.id}" target="_blank">by ${from.name}</a></div>
	                    
                                </td>
                            </tr>
                        </table>

                    </li>
                    </script>

                    <div class="appFoot">
                      <a target="_blank" href="http://www.facebook.com/<%= GetExternalComponentPropertyValue("GroupID")%>">Visit us @ Facebook</a>
                    </div>

             </div><!--[if !IE]>-----// end of Content tableMain //-----<![endif]-->     
               
        </asp:PlaceHolder>
		
		<!--[if !IE]>-----// Edit View //-----<![endif]-->
		<asp:PlaceHolder ID="EditMode" runat="server"></asp:PlaceHolder>
         
    </form>
   
</body>
</html>