pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
  id: root

  property bool dnd: false

  // Full history (shown in the side panel) until dismissed
  readonly property var list: server.trackedNotifications
  // Same data, newest first (used by the side panel list)
  readonly property var history: server.trackedNotifications.values.slice().reverse()
  readonly property int count: server.trackedNotifications.values.length

  // Notifications currently shown as on-screen toasts
  property var popups: []

  function hidePopup(n) {
    root.popups = root.popups.filter(p => p !== n);
  }

  function clearAll() {
    const all = server.trackedNotifications.values.slice();
    for (const n of all) n.dismiss();
    root.popups = [];
  }

  Component {
    id: popupTimer
    Timer {
      property var notif
      running: true
      repeat: false
      onTriggered: {
        root.hidePopup(notif);
        destroy();
      }
    }
  }

  NotificationServer {
    id: server
    keepOnReload: true
    bodySupported: true
    actionsSupported: true
    imageSupported: true

    onNotification: n => {
      n.tracked = true; // keep in history

      const critical = n.urgency === NotificationUrgency.Critical;
      if (root.dnd && !critical) return; // history only, no toast

      root.popups = [n, ...root.popups];
      n.closed.connect(() => root.hidePopup(n));

      // Critical toasts stay until dismissed; others time out
      if (!critical) {
        popupTimer.createObject(root, {
          notif: n,
          interval: n.expireTimeout > 0 ? n.expireTimeout * 1000 : 5000
        });
      }
    }
  }
}
