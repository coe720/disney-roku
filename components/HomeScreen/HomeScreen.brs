sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)

    ' Observe visibility changes of the HomeScreen so we can focus it
    m.top.ObserveField("visible", "OnVisibleChange")

    ' Observe rowItemFocused so we know when another item will be focused
    m.rowList.ObserveField("rowItemFocused", "OnRowItemFocused")
end sub

sub OnVisibleChange() ' invoked when GridScreen change visibility
    if m.top.visible = true
        m.rowList.SetFocus(true) ' set focus to rowList if GridScreen visible
    end if
end sub

' Invoked when a row item is focused
sub OnRowItemFocused()
    focusedIndex = m.rowList.rowItemFocused

    ' Get all of the items in the row
    row = m.rowList.content.GetChild(focusedIndex[0])

    ' Finally get the focused item
    item = row.GetChild(focusedIndex[1])
end sub
