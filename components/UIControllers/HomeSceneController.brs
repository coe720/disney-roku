sub RunFetchHomeContentTask()
  m.homeContentTask = createObject("roSGNode", "HomeContentLoader")
  m.homeContentTask.observeField("content", "OnHomeContentLoaded")
  m.homeContentTask.contentUri = "https://cd-static.bamgrid.com/dp-117731241344/home.json"
  m.homeContentTask.control = "RUN"

  ShowLoadingSpinner()
end sub

sub OnHomeContentLoaded()
  m.HomeScreen.SetFocus(true)

  HideLoadingSpinner()

  m.HomeScreen.content = m.homeContentTask.content
end sub

sub ShowHomeScreen()
  m.HomeScreen = CreateObject("roSGNode", "HomeScreen")
  m.HomeScreen.ObserveField("rowItemSelected", "OnHomeScreenItemSelected")

  ShowScreen(m.HomeScreen)
end sub

' Invoked when a tile is selected on the home screen
sub OnHomeScreenItemSelected(event as object)
  homeScreenGrid = event.GetRoSGNode()

  ' Get the row and column index of the user selection
  m.selectedIndex = event.GetData()

  rowContent = homeScreenGrid.content.GetChild(m.selectedIndex[0])

  ' Show the Content Details Screen to show more info about the selection
  ShowContentDetailsScreen(rowContent, m.selectedIndex[1])
end sub