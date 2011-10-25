Imports IntranetDASHBOARD.API

Namespace _SNAP
    Public Class FacebookComponent
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
    End Class

End Namespace

