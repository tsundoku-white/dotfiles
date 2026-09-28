import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
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
  readonly property color accentBorder: Colors.tint(Colors.accent, 0.45)

  // ── Panel geometry ───────────────────────────────────────────────────
  readonly property int maxVisible: 5
  readonly property int panelWidth: Math.round(width / 7)
  readonly property int panelHeight: Math.round(height * 0.9)

  // ── State ────────────────────────────────────────────────────────────
  // Notification data lives in the Notifs singleton (Notifs.qml)

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
      color: mouse.containsMouse ? Colors.bg : Colors.textSecondary
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
    color: active ? root.accentFill : (tglMouse.containsMouse ? Colors.bgHover : Colors.bgElevated)
    border.width: 1
    border.color: active ? root.accentBorder : Colors.divider

    Behavior on color { ColorAnimation { duration: 120 } }

    Text {
      anchors.centerIn: parent
      text: tgl.label
      color: tgl.active ? Colors.accent : Colors.textSecondary
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

    MouseArea {
      anchors.fill: parent
    }

    // ── Quick toggles ──────────────────────────────────────────────────
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
        active: Notifs.dnd
        onClicked: Notifs.dnd = !Notifs.dnd
      }
    }

    // ── Notifications Header ───────────────────────────────────────────
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
        text: Notifs.count
        color: Colors.textSecondary
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

      ToggleButton {
        width: parent.width
        label: "Clear all"
        onClicked: Notifs.clearAll()
      }
    }

    // ── Notification Container Box ─────────────────────────────────────
    ListView {
      id: notifListView
      anchors.top: notifButtons.bottom
      anchors.bottom: footer.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 12
      spacing: 6
      clip: true
      model: Notifs.history

      delegate: Rectangle {
        required property var modelData

        width: notifListView.width
        height: 70
        color: Colors.bgSurface
        radius: 6

        Column {
          anchors.fill: parent
          anchors.margins: 8
          spacing: 2

          Text {
            width: parent.width
            text: modelData.appName + " · " + modelData.summary
            color: Colors.textPrimary
            font.bold: true
            font.pixelSize: 12
            elide: Text.ElideRight
          }

          Text {
            width: parent.width
            text: modelData.body
            color: Colors.textSecondary
            font.pixelSize: 11
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
          }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: modelData.dismiss()
        }
      }
    }

    // ── Footer ─────────────────────────────────────────────────────────
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
        color: Colors.divider
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
          color: Colors.textSecondary
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
