﻿Imports IntranetDASHBOARD.API


Namespace _SocialNetworking
    Public Class DefaultPage
        Inherits iDCMSComponent

        Protected Overrides Sub OnLoad(ByVal e As EventArgs)
            ' Insert code that should run each time the iD CMS Component loads.
            ' Call the underlying OnLoad, which will call OnLoadOfDisplayMode and OnLoadOfEditMode as required.

            MyBase.OnLoad(e)
        End Sub

        Protected Overrides Sub OnLoadOfEditMode()
            ' Insert code that will be run when the iD CMS Component is changed to edit mode.

        End Sub

        Protected Overrides Sub OnLoadOfDisplayMode()
            ' Insert code that will be run when the iD CMS Component is changed to display mode.
        End Sub

        Protected Overrides Sub Render(ByVal writer As System.Web.UI.HtmlTextWriter)
            ' Post Rending jquery due to inbuilt conflict.
            MyBase.Render(writer)
            writer.Write("<script src=""http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js""></script>")
            writer.Write("<script src=""js/jquery.tmpl.min.js""></script>")
            writer.Write("<script src=""js/FacebookScript.aspx?groupId=" & GetExternalComponentPropertyValue("GroupID") & "&accessToken=" & GetExternalComponentPropertyValue("AccessToken") & "&limit=" & GetExternalComponentPropertyValue("limit") & """></script>")
        End Sub

    End Class

End Namespace