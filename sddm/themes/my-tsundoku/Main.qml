import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
  id: root
  width: parent ? parent.width : 1920
  height: parent ? parent.height : 1080
  color: "#141414"

  property string currentUser: userModel.lastUser
  property bool loginFailed: false
  property int sessionIndex: {
    for (var i = 0; i < sessionModel.rowCount(); i++) {
      var name = (sessionModel.data(sessionModel.index(i, 0), Qt.DisplayRole) || "").toString()
      if (name.indexOf("uwsm") !== -1)
      return i
    }
    return sessionModel.lastIndex
  }

  Connections {
    target: sddm
    function onLoginFailed() {
      root.loginFailed = true
      password.text = ""
      password.focus = true
    }
    function onLoginSucceeded() {
      root.loginFailed = false
    }
  }

  Column {
    anchors.centerIn: parent
    spacing: Math.max(20, root.height * 0.04)

//    Image {
//      id: logo
//      source: "logo.png"
//      width: Math.min(sourceSize.width, root.width * 0.8)
//      height: sourceSize.width > 0 ? Math.round(width * sourceSize.height / sourceSize.width) : 0
//      fillMode: Image.PreserveAspectFit
//      anchors.horizontalCenter: parent.horizontalCenter
//    }

    Row {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 15

      Item {
        width: entry.width
        height: entry.height

        Image {
          id: entry
          source: root.loginFailed ? "entry-failed.png" : "entry.png"
          anchors.centerIn: parent
        }

        Row {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          spacing: 5

          Repeater {
            model: Math.min(password.text.length, 21)

            Image {
              source: "bullet.png"
              width: 7
              height: 7
            }
          }
        }

        TextInput {
          id: password
          anchors.fill: parent
          horizontalAlignment: TextInput.AlignHCenter
          verticalAlignment: TextInput.AlignVCenter
          echoMode: TextInput.Password
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 24
          font.letterSpacing: 5
          passwordCharacter: "\u2022"
          color: "transparent"
          selectionColor: "transparent"
          selectedTextColor: "transparent"
          cursorDelegate: Item {}
          focus: true

          onTextChanged: root.loginFailed = false

        }
      }
    }
  }


Component.onCompleted: password.forceActiveFocus()
}
