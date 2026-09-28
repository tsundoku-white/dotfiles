import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick

PanelWindow {
  id: win

  visible: Notifs.popups.length > 0
  color: "transparent"

  anchors {
    top: true
    right: true
  }
  margins {
    top: 8
    right: 8
  }

  implicitWidth: 360
  implicitHeight: stack.implicitHeight

  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell-notifications"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  Column {
    id: stack
    width: parent.width
    spacing: 8

    Repeater {
      model: Notifs.popups

      delegate: Rectangle {
        id: card
        required property var modelData

        readonly property bool critical: modelData.urgency === NotificationUrgency.Critical

        width: stack.width
        implicitHeight: content.implicitHeight + 24
        radius: Colors.radiusPanel
        color: Colors.bgElevated
        border.width: 1
        border.color: critical ? Colors.accentRed : Colors.dividerStrong

        // Click card: hide the toast (stays in side panel history)
        MouseArea {
          anchors.fill: parent
          onClicked: Notifs.hidePopup(card.modelData)
        }

        Column {
          id: content
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.margins: 12
          spacing: 4

          Item {
            width: parent.width
            height: 18

            Text {
              anchors.left: parent.left
              anchors.right: closeBtn.left
              anchors.verticalCenter: parent.verticalCenter
              text: card.modelData.appName
              color: Colors.textSecondary
              font.pixelSize: 11
              elide: Text.ElideRight
            }

            // Dismiss fully (removes from history too)
            Text {
              id: closeBtn
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              text: "X"
              color: closeMouse.containsMouse ? Colors.accentRed : Colors.textSecondary
              font.pixelSize: 17

              MouseArea {
                id: closeMouse
                anchors.fill: parent
                anchors.margins: -6
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: card.modelData.dismiss()
              }
            }
          }

          Text {
            width: parent.width
            text: card.modelData.summary
            color: Colors.textPrimary
            font.bold: true
            font.pixelSize: 13
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
          }

          Text {
            width: parent.width
            visible: text.length > 0
            text: card.modelData.body
            color: Colors.textSecondary
            font.pixelSize: 12
            wrapMode: Text.WordWrap
            maximumLineCount: 4
            elide: Text.ElideRight
          }

          // Notification actions (e.g. "Reply", "Open")
          Row {
            spacing: 6
            visible: card.modelData.actions.length > 0

            Repeater {
              model: card.modelData.actions

              delegate: Rectangle {
                required property var modelData
                height: 26
                width: label.implicitWidth + 20
                radius: 6
                color: actMouse.containsMouse ? Colors.bgHover : "transparent"
                border.width: 1
                border.color: Colors.dividerStrong

                Text {
                  id: label
                  anchors.centerIn: parent
                  text: parent.modelData.text
                  color: Colors.textPrimary
                  font.pixelSize: 11
                }

                MouseArea {
                  id: actMouse
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor
                  onClicked: {
                    parent.modelData.invoke();
                    Notifs.hidePopup(card.modelData);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
