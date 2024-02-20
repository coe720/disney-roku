sub ShowContentDetailsScreen(content as object, selectedItem as integer)

    ' Create an instance the content details screen
    contentDetailsScreen = CreateObject("roSGNode", "ContentDetailsScreen")
    contentDetailsScreen.content = content
    ' Tell the details screen which item in the row is selected,
    ' we'll be able to cycle through them on the actual screen
    contentDetailsScreen.selectedItem = selectedItem
    contentDetailsScreen.ObserveField("visible", "OnContentDetailsScreenVisibilityChanged")

    ' Add the screen to the stack
    ShowScreen(contentDetailsScreen)
end sub

sub OnContentDetailsScreenVisibilityChanged(event as object)
    visible = event.GetData()
    contentDetailsScreen = event.GetRoSGNode()

    ' If the details screen is no longer visible then re-focus on the index we were on
    if visible = false
        m.HomeScreen.selectedItem = [m.selectedIndex[0], contentDetailsScreen.itemFocused]
    end if
end sub

