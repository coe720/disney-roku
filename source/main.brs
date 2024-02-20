sub Main()
  ShowRootScreen()
end sub

sub ShowRootScreen()
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  scene = screen.CreateScene("RootScene")
  screen.Show()

  scene.observeField("leaveChannel", m.port)

  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)

    if msgType = "roSGScreenEvent"
      if msg.isScreenClosed()
        return
      end if

    else if msgType = "roSGNodeEvent"
      field = msg.getField()

      if field = "leaveChannel"
        return
      end if
    end if
  end while
end sub
