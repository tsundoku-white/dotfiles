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

  AppLauncher {
    screen: Quickshell.screens.find(s => s.name === mainMonitor)
  }
}
