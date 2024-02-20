sub ShowLoadingSpinner()
  m.loadingSpinner = m.top.FindNode("loadingSpinner")
  m.loadingSpinner.poster.uri = "pkg:/images/disney-circular-loader.png"

  m.loadingSpinner.visible = true
end sub

sub HideLoadingSpinner()
  m.loadingSpinner.visible = false
end sub