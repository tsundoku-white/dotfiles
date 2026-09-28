import Quickshell
import Quickshell.Io
import "."

ShellRoot {
  // Name of the output the launcher should always appear on.
  // Must match an output name from `hyprctl monitors` (e.g. "DP-1").
  readonly property string mainMonitor: "DP-1"

  IpcHandler {
    target: "applauncher"

    function toggle() {
      AppLauncherState.toggle();
    }
  }

  IpcHandler {
    target: "sidepannel"

    function toggle() {
      AppSidePannelState.toggle();
    }
  }

  AppLauncher {
    screen: Quickshell.screens.find(s => s.name === mainMonitor)
  }

  SidePannel {
    screen: Quickshell.screens.find(s => s.name === mainMonitor)
  }

  NotificationPopups {
    screen: Quickshell.screens.find(s => s.name === mainMonitor)
  }
}
