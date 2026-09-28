import Quickshell
import Quickshell.Wayland
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
    item: AppLauncherState.launcherVisible ? maskCover : null
  }

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "quickshell-launcher"
  WlrLayershell.keyboardFocus: AppLauncherState.launcherVisible
    ? WlrKeyboardFocus.Exclusive
    : WlrKeyboardFocus.None

  // ── State ────────────────────────────────────────────────────────────
  property string searchQuery: ""
  property int selectedIndex: 0
  readonly property bool isSearching: searchQuery.trim() !== ""

  property var filteredApps: {
    const query = searchQuery.trim().toLowerCase();
    const apps = DesktopEntries.applications.values;

    if (query !== "") {
      return apps.filter(entry => {
        if (entry.name.toLowerCase().indexOf(query) !== -1)
          return true;
        if (entry.genericName && entry.genericName.toLowerCase().indexOf(query) !== -1)
          return true;
        return entry.keywords.some(keyword => keyword.toLowerCase().indexOf(query) !== -1);
      }).sort((a, b) => a.name.localeCompare(b.name));
    }

    // Default mode: recently launched apps first, then alphabetical.
    const recent = AppLauncherState.recentIds;
    return apps.slice().sort((a, b) => {
      const aIndex = recent.indexOf(a.id);
      const bIndex = recent.indexOf(b.id);

      if (aIndex !== -1 && bIndex !== -1)
        return aIndex - bIndex;
      if (aIndex !== -1)
        return -1;
      if (bIndex !== -1)
        return 1;
      return a.name.localeCompare(b.name);
    });
  }

  onFilteredAppsChanged: selectedIndex = 0

  // ── Actions ──────────────────────────────────────────────────────────
  function launchEntry(entry) {
    AppLauncherState.recordLaunch(entry.id);
    entry.execute();
    AppLauncherState.hide();
  }

  function navigate(delta) {
    if (filteredApps.length === 0)
      return;

    selectedIndex = (selectedIndex + delta + filteredApps.length) % filteredApps.length;
    listView.positionViewAtIndex(selectedIndex, ListView.Contain);
  }

  Connections {
    target: AppLauncherState

    function onLauncherVisibleChanged() {
      if (!AppLauncherState.launcherVisible)
        return;

      searchInput.text = "";
      root.searchQuery = "";
      root.selectedIndex = 0;
      searchInput.forceActiveFocus();
    }
  }

  // ── Theming ──────────────────────────────────────────────────────────
  readonly property color accentFill: Colors.tint(Colors.accent, 0.18)
  readonly property color accentIcon: Colors.tint(Colors.accent, 0.28)
  readonly property color fgDim: Colors.tint(Colors.textPrimary, 0.65)

  // ── Panel geometry ───────────────────────────────────────────────────
  readonly property int maxVisible: 5
  readonly property int itemHeight: 40
  readonly property int panelWidth: 550

  // 12 top padding + 44 search box + 8 spacing + list + 12 bottom padding
  readonly property int panelHeight: {
    if (AppLauncherState.launcherVisible && isSearching)
      return 65 + Math.min(filteredApps.length, maxVisible) * itemHeight;
    return 65; // Just the search box.
  }

  // Click outside the panel to close.
  MouseArea {
    anchors.fill: parent
    enabled: AppLauncherState.launcherVisible
    onClicked: AppLauncherState.hide()
  }

  // ── Panel ────────────────────────────────────────────────────────────
  Rectangle {
    id: panel

    width: root.panelWidth
    height: root.panelHeight
    clip: true

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    color: Colors.bg
    topLeftRadius: Colors.radiusPanel
    topRightRadius: Colors.radiusPanel
    bottomLeftRadius: 0
    bottomRightRadius: 0
    border.width: 0
    border.color: Colors.divider

    Behavior on height {
      NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
    }

    // Slide up when visible, down out of view when hidden.
    transform: Translate {
      y: AppLauncherState.launcherVisible ? 0 : root.panelHeight + 6

      Behavior on y {
        NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
      }
    }

    layer.enabled: true
    layer.effect: MultiEffect {
      shadowEnabled: true
      shadowColor: Colors.shadowColor
      shadowBlur: Colors.shadowBlur
      shadowHorizontalOffset: 0
      shadowVerticalOffset: -4
    }

    Column {
      anchors {
        top: parent.top
        topMargin: 12
        left: parent.left
        leftMargin: 12
        right: parent.right
        rightMargin: 12
      }
      spacing: 0

      // ── Search box ─────────────────────────────────────────────────
      Rectangle {
        width: parent.width
        height: 46
        radius: Colors.radiusButton
        color: Colors.bgElevated
        border.width: 1
        border.color: Colors.divider

        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: "transparent"
          border.width: 1.5
          border.color: Colors.accent
          opacity: searchInput.activeFocus ? 0.7 : 0

          Behavior on opacity {
            NumberAnimation { duration: 150 }
          }
        }

        Text {
          anchors.left: parent.left
          anchors.leftMargin: 14
          anchors.verticalCenter: parent.verticalCenter
          text: "\uf002" // Search glyph.
          font.pixelSize: 15
          font.weight: Font.Bold

          color: searchInput.activeFocus ? Colors.accent : Colors.textMuted

          Behavior on color {
            ColorAnimation { duration: 150 }
          }
        }

        Item {
          anchors.fill: parent
          anchors.leftMargin: 38
          anchors.rightMargin: 14

          Text {
            anchors.fill: parent
            text: "Search..."
            color: Colors.textPrimary
            opacity: 0.28
            font.pixelSize: 13
            font.family: "Inter, Segoe UI, Roboto, sans-serif"
            verticalAlignment: Text.AlignVCenter
            visible: searchInput.text === ""
          }

          TextInput {
            id: searchInput

            anchors.fill: parent
            clip: true
            color: Colors.textPrimary
            selectionColor: root.accentFill
            font.pixelSize: 15
            font.family: "Inter, Segoe UI, Roboto, sans-serif"
            verticalAlignment: TextInput.AlignVCenter

            onTextChanged: root.searchQuery = text

            Keys.onPressed: event => {
              switch (event.key) {
              case Qt.Key_Up:
                root.navigate(-1);
                event.accepted = true;
                break;
              case Qt.Key_Down:
                root.navigate(1);
                event.accepted = true;
                break;
              case Qt.Key_Return:
              case Qt.Key_Enter:
                if (root.filteredApps.length > 0)
                  root.launchEntry(root.filteredApps[root.selectedIndex]);
                event.accepted = true;
                break;
              case Qt.Key_Escape:
                AppLauncherState.hide();
                event.accepted = true;
                break;
              }
            }
          }
        }
      }

      Item {
        width: 1
        height: 8
      }

      // ── App list ─────────────────────────────────────────────────────
      ListView {
        id: listView

        width: parent.width
        height: Math.min(root.filteredApps.length, root.maxVisible) * root.itemHeight
        model: root.filteredApps
        clip: true
        interactive: false
        visible: root.isSearching

        MouseArea {
          anchors.fill: parent
          onWheel: wheel => root.navigate(wheel.angleDelta.y < 0 ? 1 : -1)
        }

        Text {
          anchors.centerIn: parent
          visible: root.filteredApps.length === 0
          text: "No matches"
          color: Colors.textPrimary
          opacity: 0.28
          font.pixelSize: 13
          font.family: "Inter, Segoe UI, Roboto, sans-serif"
        }

        delegate: Item {
          id: appRow

          width: listView.width
          height: root.itemHeight

          readonly property bool selected: root.selectedIndex === index
          readonly property bool isRecent: !root.isSearching
            && AppLauncherState.recentIds.indexOf(modelData.id) !== -1
            && AppLauncherState.recentIds.indexOf(modelData.id) < 5

          Rectangle {
            anchors.fill: parent
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            radius: 10
            color: "transparent"

            Behavior on color {
              ColorAnimation { duration: 100 }
            }

            // Left accent bar on the selected row.
            Rectangle {
              anchors.left: parent.left
              anchors.top: parent.top
              anchors.bottom: parent.bottom
              anchors.margins: 4
              width: 3
              radius: 2
              color: Colors.accent
              opacity: appRow.selected ? 1 : 0

              Behavior on opacity {
                NumberAnimation { duration: 100 }
              }
            }

            Row {
              anchors.fill: parent
              anchors.leftMargin: 8
              anchors.rightMargin: 8
              spacing: 12

              // Icon bubble.
              Rectangle {
                width: 40
                height: 40
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"

                Image {
                  id: appIcon

                  anchors.centerIn: parent
                  width: 30
                  height: 30
                  source: modelData.icon !== "" ? "image://icon/" + modelData.icon : ""
                  smooth: true
                  mipmap: true
                }

                Text {
                  anchors.centerIn: parent
                  visible: appIcon.status !== Image.Ready
                  text: modelData.name.charAt(0).toUpperCase()
                  font.pixelSize: appRow ? 15 : 17
                  font.family: "Inter, Segoe UI, Roboto, sans-serif"
                  font.weight: appRow ? Font.Bold : Font.Normal
                  color: appRow.selected ? Colors.accent : Colors.textPrimary

                  Behavior on color {
                    ColorAnimation { duration: 100 }
                  }
                }
              }

              // Name and subtitle.
              Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                  text: modelData.name
                  font.pixelSize: appRow.selected ? 15 : 13
                  font.family: "Inter, Segoe UI, Roboto, sans-serif"
                  font.weight: appRow.selected ? Font.Bold : Font.Normal
                  color: appRow.selected ? Colors.textPrimary : root.fgDim

                  Behavior on color {
                    ColorAnimation { duration: 100 }
                  }
                }

                Row {
                  spacing: 6
                  visible: appRow.isRecent || modelData.genericName !== ""

                  Rectangle {
                    visible: appRow.isRecent
                    width: recentLabel.width + 8
                    height: 14
                    radius: 4
                    color: Colors.tint(Colors.accent, 0.30)
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                      id: recentLabel

                      anchors.centerIn: parent
                      text: "recent"
                      font.pixelSize: 12
                      font.family: "Inter, Segoe UI, Roboto, sans-serif"
                      color: Colors.accent
                    }
                  }
                }
              }
            }

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              onEntered: root.selectedIndex = index
              onClicked: root.launchEntry(modelData)
              onWheel: wheel => root.navigate(wheel.angleDelta.y < 0 ? 1 : -1)
            }
          }
        }
      }

      Item {
        width: 1
        height: 4
      }
    }
  }
}
