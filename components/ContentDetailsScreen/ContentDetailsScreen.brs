function Init()
    ' Observe when the Content Details Screen changes visibility
    m.top.ObserveField("visible", "OnVisibleChange")

    ' Observe when a new item is focused
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")

    m.poster = m.top.FindNode("poster")
    m.ratingLabel = m.top.FindNode("ratingLabel")
    m.releaseYearLabel = m.top.FindNode("releaseYearLabel")

    ' m.watchPreviewButton = m.top.FindNode("WatchPreviewButton")

    m.top.SetFocus(true)
end function

sub OnVisibleChange()
    if m.top.visible = true
        m.top.itemFocused = m.top.selectedItem
    end if
end sub

sub PopulateContentDetails(content as object)
    ' If we have a preview available to watch then make the button visible
    ' if content.preview <> invalid
    '     m.watchPreviewButton.ObserveField("buttonSelected", "OnWatchPreviewButtonSelected")
    '     m.watchPreviewButton.visible = true
    '     m.watchPreviewButton.SetFocus(true)
    ' end if

    m.poster.uri = content.tileUrl
    m.ratingLabel.text = content.ratings[0].value
    m.releaseYearLabel.text = content.releases[0].releaseYear
end sub

' Invoke when the selected item is updated
sub OnSelectedItem()
    content = m.top.content
    ' Check if selectedItem field has valid value
    if content <> invalid and m.top.selectedItem >= 0 and content.GetChildCount() > m.top.selectedItem
        m.top.itemFocused = m.top.selectedItem
    end if
end sub

' Invoke this when we have a new item being selected
sub OnItemFocusedChanged(event as object)
    ' Get the focused item
    focusedItem = event.GetData()

    ' Get the content of the newly focused item
    content = m.top.content.GetChild(focusedItem)

    PopulateContentDetails(content)
end sub

' Use this so we can cycle between row items while in the content details page
function OnkeyEvent(key as string, press as boolean) as boolean
    result = false

    if press
        ' Position of currently focused item
        currentItem = m.top.itemFocused

        ' Cycle left or right depending if the left or rigth key is pressed
        if key = "left"
            m.top.selectedItem = currentItem - 1

            result = true
        else if key = "right"
            m.top.selectedItem = currentItem + 1

            result = true
        end if
    end if

    return result
end function