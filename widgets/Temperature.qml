import "./../components"
import QtQuick
import Quickshell.Io

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20
    bottomLeftRadius: 20
    hoverEnabled: false

    FileView {
        id: file

        path: "/sys/class/thermal/thermal_zone6/temp"
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: file.reload()
    }

    MyRow {
        id: panelLayout

        anchors.verticalCenter: panelBox.verticalCenter

        MyLabel {
            id: panelIcon

            anchors.verticalCenter: panelLayout.verticalCenter
            color: colorDrawer.temperatureGradient[panelLabel.temp]
            text: ""
            font.family: "Font Awesome 6 Brands"
        }

        MyLabel {
            id: panelLabel

            property int temp: Math.round(file.text() / 1000)

            anchors.verticalCenter: panelLayout.verticalCenter
            color: colorDrawer.temperatureGradient[temp]
            text: temp + "°C"
            font.family: "Fira Code"
        }
    }
}
