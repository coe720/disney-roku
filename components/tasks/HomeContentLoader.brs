sub Init()
  m.top.functionName = "LoadHomeContent"
end sub

sub LoadHomeContent()
  try
    ' Retrieve the home page grid content
    fetchContent = createObject("roUrlTransfer")
    fetchContent.SetCertificatesFile("common:/certs/ca-bundle.crt")
    fetchContent.setUrl(m.top.contentUri)

    retrievedContent = fetchContent.GetToString()
    retrievedContentJson = ParseJson(retrievedContent)

    if retrievedContentJson?.data?.StandardCollection <> invalid
      homeRootContent = []

      for each contentContainer in retrievedContentJson.data.StandardCollection.containers
        ' Setup the row to be populated
        homeContentRowTitle = contentContainer?.set?.text?.title?.full?.set?.default?.content
        homeContentRow = {}
        homeContentRow.title = homeContentRowTitle
        homeContentRow.children = []

        if contentContainer?.set?.items <> invalid

          ' Loop through each content row's tiles
          for each homeContentRowItem in contentContainer.set.items

            ' Get the data for the tile
            tileData = RetrieveTileData(homeContentRowItem, contentContainer.set.contentClass)

            ' Only add the tile to the row if we have the data we need to display it
            if tileData <> invalid
              homeContentRow.children.push(tileData)
            end if
          end for

          ' Add the row to what will be set to the content node only if we have tiles to show
          if homeContentRow.Count() > 0
            homeRootContent.Push(homeContentRow)
          end if
        end if
      end for

      contentNode = CreateObject("roSGNode", "ContentNode")
      contentNode.Update({
        children: homeRootContent
      }, true)

      m.top.content = contentNode
    end if

    ' Ideally here if we didn't have data or an error is thrown we would want to show a dialog
    ' to tell the user something went wrong, and potentially present a retry
    ' button to try and fetch the content again
  catch error
    print error
  end try
end sub

function RetrieveTileData(tileData as object, contentClass as string) as object
  ' Check if the content is available, this is a simplified check but should check against the current user's region
  ' Also check that the content is a collection of shows/movies because collections will not have an availability
  if tileData.currentAvailability <> invalid or tileData.currentAvailability = invalid and contentClass <> "editorial"
    tileImageData = tileData.image.tile["1.78"]
    tile = {}
    foundTileData = invalid
    contentType = invalid

    ' Check the content type so we know where to find the tile poster we need
    if tileImageData.series <> invalid
      foundTileData = tileImageData.series
      contentType = "series"
    else if tileImageData.program <> invalid
      foundTileData = tileImageData.program
      contentType = "program"
    else if tileImageData.default <> invalid
      foundTileData = tileImageData.default
      contentType = "default"
    end if

    ' Check that we actually have an image URL
    if foundTileData?.default?.url <> invalid

      ' Test the image URL to verify it exists, otherwise don't add the tile to the row
      fetchTilePosterCheck = CreateObject("roUrlTransfer")
      fetchTilePosterCheck.SetCertificatesFile("common:/certs/ca-bundle.crt")
      fetchTilePosterCheck.setUrl(foundTileData?.default?.url)

      headResponse = fetchTilePosterCheck.head()

      if headResponse <> invalid

        ' Get the response code
        responseCode = headResponse.getResponseCode()

        ' We have an image we can retrieve
        if responseCode = 200
          ' We have all the data we need to show the tile. Add additional data which will be used
          ' by the details screen
          tile.tileUrl = foundTileData.default.url
          tile.contentType = contentType
          tile.ratings = tileData.ratings
          tile.releases = tileData.releases

          ' For this use case we're going to use video art as a preview on the details screen
          if tileData.videoArt <> invalid and tileData.videoArt.Count() > 0
            ' Just use the first entry if it exists, we'll use this for a video preview
            if tileData?.videoArt[0]?.mediaMetadata?.urls <> invalid and tileData?.videoArt[0]?.mediaMetadata?.urls.Count() > 0
              ' This isn't a real preview but we're going to use it as one
              tile.preview = tileData?.videoArt[0]?.mediaMetadata?.urls[0].url
            end if
          end if

          return tile
        else
          ' If the response isn't a 200 we should send an error report back to us
        end if
      end if
    end if
  end if

  ' If we didn't have the right data for the user to view this then return invalid
  return invalid
end function