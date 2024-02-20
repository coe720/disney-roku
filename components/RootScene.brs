sub Init()
  SetChannelBackground()

  ' Setup the screen stack for navigation
  InitScreenStack()


  ShowHomeScreen()
  RunFetchHomeContentTask()
end sub

function OnKeyEvent(key as string, press as boolean) as boolean
  ' Check if the back button is pressed and if we're on the home screen
  if press and key = "back" and IsOnHomeScreen() then

    ' Create a dialog to ask the user if they want to leave the channel
    dialog = createObject("roSGNode", "StandardMessageDialog")

    dialog.message = ["Are you sure you want to leave?"]
    dialog.buttons = ["No", "Yes"]

    ' Observe dialog buttons being pressed
    dialog.observeFieldScoped("buttonSelected", "OnDialogButtonClick")

    ' Show the dialog
    m.top.dialog = dialog

    return true
  else if press and key = "back"
    ' If we're not on the home screen then just close the current screen
    CloseScreen(invalid)

    return true
  end if
end function

function OnDialogButtonClick(event)
  buttonIndex = event.getData()
  ' User has clicked Yes
  if buttonIndex = 1 then
    ' The main loop is waiting on leaveChannel to be set
    m.top.leaveChannel = true
  else
    ' Close the dialog
    m.top.dialog.close = true
    return true
  end if
end function