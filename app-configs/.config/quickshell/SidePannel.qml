import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick
import QtQuick.Effects

PanelWindow {
  id: root

  color: "transparent"

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  // Only capture input while the panel is open (full-screen so click-outside closes it)
  mask: Region {
    item: AppSidePannelState.visible ? maskCover : null
  }

  Shortcut {
    sequence: "Escape"
    enabled: AppSidePannelState.visible
    onActivated: AppSidePannelState.hide()
  }

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell-side-panel"
  WlrLayershell.keyboardFocus: AppSidePannelState.visible
  ? WlrKeyboardFocus.OnDemand
  : WlrKeyboardFocus.None

  // ── Theming ──────────────────────────────────────────────────────────
  readonly property color accentFill: Colors.tint(Colors.accent, 0.18)
  readonly property color accentIcon: Colors.tint(Colors.accent, 0.28)
  readonly property color fgDim: Colors.tint(Colors.textPrimary, 0.65)

  // ── Panel geometry ───────────────────────────────────────────────────
  readonly property int maxVisible: 5
  readonly property int panelWidth: Math.round(width / 7)
  readonly property int panelHeight: Math.round(height * 0.9)
  readonly property int itemHeight: Math.round(panelHeight / maxVisible)

  // ── State (mirrored from swaync) ─────────────────────────────────────
  property bool dnd: false
  property int notifCount: 0

  // swaync-client -s prints a JSON line every time something changes:
  // {"count":0,"dnd":false,"visible":false,"inhibited":false}
  Process {
    running: true
    command: ["swaync-client", "-s"]
    stdout: SplitParser {
      onRead: line => {
        try {
          const st = JSON.parse(line);
          root.dnd = st.dnd;
          root.notifCount = st.count;
        } catch (e) {}
      }
    }
  }

  // ── Reusable power button ────────────────────────────────────────────
  component PowerButton: Rectangle {
    id: btn
    property string label: ""
    property var command: []

    width: 44
    height: 44
    radius: 10
    color: mouse.containsMouse ? Colors.accentRed : "transparent"

    Behavior on color { ColorAnimation { duration: 120 } }

    Text {
      anchors.centerIn: parent
      text: btn.label
      color: mouse.containsMouse ? Colors.bg : root.fgDim
      font.pixelSize: 20
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        AppSidePannelState.hide();
        Quickshell.execDetached(btn.command);
      }
    }
  }

  // ── Reusable toggle button ───────────────────────────────────────────
  component ToggleButton: Rectangle {
    id: tgl
    property string label: ""
    property bool active: false
    signal clicked()

    height: 44
    radius: 10
    color: active ? root.accentFill : (tglMouse.containsMouse ? Colors.divider : "transparent")
    border.width: 1
    border.color: active ? Colors.accent : Colors.divider

    Behavior on color { ColorAnimation { duration: 120 } }

    Text {
      anchors.centerIn: parent
      text: tgl.label
      color: tgl.active ? Colors.accent : root.fgDim
      font.pixelSize: 14
    }

    MouseArea {
      id: tglMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: tgl.clicked()
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  // Click outside the panel to close
  MouseArea {
    id: maskCover
    anchors.fill: parent
    enabled: AppSidePannelState.visible
    onClicked: AppSidePannelState.hide()
  }

  Rectangle {
    id: panel

    width: AppSidePannelState.visible ? root.panelWidth : 0
    height: root.panelHeight
    clip: true

    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left

    color: Colors.bg
    topLeftRadius: 0
    bottomLeftRadius: 0
    topRightRadius: Colors.radiusPanel
    bottomRightRadius: Colors.radiusPanel
    border.width: 0
    border.color: Colors.divider

    Behavior on width {
      NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    // Swallow clicks so pressing inside the panel doesn't close it
    MouseArea {
      anchors.fill: parent
    }

    // ── Quick toggles: Bluetooth + Do Not Disturb ──────────────────────
    Row {
      id: toggles
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 12
      spacing: 8

      ToggleButton {
        width: Math.max(0, (toggles.width - toggles.spacing) / 2)
        label: "Bluetooth"
        active: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
        onClicked: {
          if (Bluetooth.defaultAdapter)
            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
        }
      }

      ToggleButton {
        width: Math.max(0, (toggles.width - toggles.spacing) / 2)
        label: "Do not disturb"
        active: root.dnd
        onClicked: Quickshell.execDetached(["swaync-client", "-d", "-sw"])
      }
    }

    // ── Notifications (handled by swaync) ──────────────────────────────
    Item {
      id: notifHeader
      anchors.top: toggles.bottom
      anchors.topMargin: 16
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 12
      anchors.rightMargin: 12
      height: 24

      Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: "Notifications"
        color: Colors.textPrimary
        font.pixelSize: 14
        font.bold: true
      }

      Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: root.notifCount
        color: root.fgDim
        font.pixelSize: 13
      }
    }

    Row {
      id: notifButtons
      anchors.top: notifHeader.bottom
      anchors.topMargin: 8
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 12
      anchors.rightMargin: 12
      spacing: 8

      ToggleButton {
        width: Math.max(0, (notifButtons.width - notifButtons.spacing) / 2)
        label: "Open"
        onClicked: {
          AppSidePannelState.hide();
          Quickshell.execDetached(["swaync-client", "-t", "-sw"]);
        }
      }

      ToggleButton {
        width: Math.max(0, (notifButtons.width - notifButtons.spacing) / 2)
        label: "Clear all"
        onClicked: Quickshell.execDetached(["swaync-client", "-C", "-sw"])
      }
    }

    // ── Footer: divider line, time/date on the left, power button on the right ──
    Item {
      id: footer
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      height: 68

      Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        height: 1
        color: Colors.textPrimary
      }

      Column {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1

        Text {
          text: Qt.formatDateTime(clock.date, "HH:mm:ss")
          color: Colors.textPrimary
          font.pixelSize: 20
        }

        Text {
          text: Qt.formatDateTime(clock.date, "ddd dd/MM")
          color: root.fgDim
          font.pixelSize: 13
        }
      }

      PowerButton {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        label: "⏻"
        command: ["systemctl", "poweroff"]
      }
    }
  }
}
