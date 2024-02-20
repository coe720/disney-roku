sub Init()
    m.poster = m.top.FindNode("poster")
end sub

sub OnContentSet()
    content = m.top.tileContent
    ' Set poster URI if content is valid
    if content <> invalid
        m.poster.uri = content.tileUrl
    end if
end sub

sub OnFocus()
    scale = 1 + (m.top.focusPercent * 0.08)
    m.poster.scale = [scale, scale]
end sub
