import "./../components"
import QtQuick
import Quickshell.Io

WidgetBox {
    id: panelBox

    implicitWidth: {
        if (hoverHandler.hovered)
            return panelLayout.implicitWidth;
        else
            return shutdown.implicitWidth;
    }
    bottomRightRadius: 20
    topLeftRadius: 20
    clip: true

    Row {
        id: panelLayout

        layoutDirection: Qt.RightToLeft
        anchors.right: panelBox.right

        PowerBox {
            id: shutdown

            anchors.verticalCenter: panelLayout.verticalCenter
            text: ""
            onClickedCommand: ["shutdown", "now"]
        }

        PowerBox {
            id: reboot

            anchors.verticalCenter: panelLayout.verticalCenter
            text: ""
            onClickedCommand: ["shutdown", "-r", "now"]
        }

        PowerBox {
            id: lock

            anchors.verticalCenter: panelLayout.verticalCenter
            text: ""
            onClickedCommand: ["hyprlock"]
        }

        PowerBox {
            id: logout

            anchors.verticalCenter: panelLayout.verticalCenter
            text: ""
            onClickedCommand: ["hyprctl", "dispatch", "hl.dsp.exit()"]
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
        }
    }

    component PowerBox: WidgetBox {
        id: widgetBox

        property alias text: powerLabel.text
        property alias onClickedCommand: process.command

        implicitWidth: powerLabel.implicitWidth
        color: "transparent"
        bottomRightRadius: 20
        topLeftRadius: 20
        onClicked: mouse => {
            if (mouse.button == Qt.LeftButton)
                process.exec(process);
        }

        MyLabel {
            id: powerLabel

            leftPadding: 10
            rightPadding: 10
            font.family: "Font Awesome 6 Brands"
            anchors.centerIn: parent
            color: "white"
        }

        Process {
            id: process
        }

        states: State {
            name: "label_hover"
            when: widgetBox.widgetMouseArea.containsMouse

            PropertyChanges {
                powerLabel.color: "black"
            }
        }
    }
}
