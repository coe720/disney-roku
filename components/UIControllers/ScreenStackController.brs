' Controls screen navigation stack

sub InitScreenStack()
    ' Create the stack array
    m.screenStack = []
end sub

sub ShowScreen(node as object)
    ' Take current screen from screen stack but don't delete it
    previousScreen = m.screenStack.Peek()
    if previousScreen <> invalid
        ' Hide current screen if it exists
        previousScreen.visible = false
    end if

    ' Add the new screen to the scene
    m.top.AppendChild(node)

    ' Show the new screen
    node.visible = true
    node.SetFocus(true)

    ' Add the new screen to the screen stack
    m.screenStack.Push(node)
end sub

sub CloseScreen(node as object)
    if node = invalid or (m.screenStack.Peek() <> invalid and m.screenStack.Peek().IsSameNode(node))
        ' Remove the current screen from the stack
        currentScreen = m.screenStack.Pop()

        ' Hide the screen
        currentScreen.visible = false

        ' Remove current screen from the scene
        m.top.RemoveChild(currentScreen)

        ' Set the previous screen to be visible
        previousScreen = m.screenStack.Peek()
        if previousScreen <> invalid
            previousScreen.visible = true
            previousScreen.SetFocus(true)
        end if
    end if
end sub

function IsOnHomeScreen()
    return m.screenStack.Count() = 1
end function
