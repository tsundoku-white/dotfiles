pragma Singleton
import QtQuick

QtObject {
  id: root

  property bool launcherVisible: false
  property var recentIds: []

  readonly property int maxRecent: 10

  function toggle() {
    launcherVisible = !launcherVisible;
  }

  function show() {
    launcherVisible = true;
  }

  function hide() {
    launcherVisible = false;
  }

  function recordLaunch(id) {
    const ids = recentIds.slice();
    const idx = ids.indexOf(id);

    if (idx !== -1)
      ids.splice(idx, 1);

    ids.unshift(id);
    recentIds = ids.slice(0, maxRecent);
  }
}
