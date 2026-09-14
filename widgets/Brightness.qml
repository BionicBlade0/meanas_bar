import "./../components"
import QtQuick
import Quickshell.Io

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20 * panel.scale
    bottomLeftRadius: 20 * panel.scale
    hoverEnabled: false

    FileView {
        id: brightnessFile

        path: "/sys/class/backlight/intel_backlight/brightness"
        watchChanges: true
        onFileChanged: {
            this.reload();
        }
    }

    MyRow {
        id: panelLayout

        anchors {
            right: panelBox.right
            verticalCenter: panelBox.verticalCenter
        }

        MyLabel {
            id: panelIcon

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Font Awesome 6 Pro"
            color: "white"
            text: ""
        }

        MyLabel {
            id: panelLabel

            anchors.verticalCenter: panelLayout.verticalCenter
            color: "white"
            font.family: "Fira Code"
            text: Math.round(brightnessFile.text() / 7500 * 100) + "%"
        }
    }

    DataDisplay {
        icon: ""
        text: panelLabel.text
    }
}
