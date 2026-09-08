import QtQuick
import Quickshell
import Quickshell.Io

import qs.bar
import qs.power
import qs.services
import qs.wallpaper

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Bar {
            property var modelData
            screen: modelData
        }
    }


     PowerMenu {}

    IpcHandler {
        target: "power"

        function toggle(): void {
            PowerService.toggleFocused()
        }

        function open(): void {
            PowerService.open(
                PowerService.focusedScreenName()
            )
        }

        function close(): void {
            PowerService.close()
        }
    }

      WallpaperMenu {}

      IpcHandler {
          target: "wallpaper"

          function toggle(): void {
              WallpaperService.toggle()
          }

          function open(): void {
              WallpaperService.open()
          }

          function close(): void {
              WallpaperService.close()
          }
      }


}
