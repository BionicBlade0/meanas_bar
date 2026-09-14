import "./../components"
import QtQuick

WidgetBox {
    id: panelBox

    property var datetime

    implicitWidth: panelLayout.implicitWidth
    bottomRightRadius: 20 * panel.scale
    topLeftRadius: 20 * panel.scale
    hoverEnabled: false

    MyRow {
        id: panelLayout

        anchors.verticalCenter: panelBox.verticalCenter

        MyLabel {
            id: panelIcon

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Font Awesome 6 Pro"
            color: "white"
            text: ""
        }

        MyLabel {
            id: panelLabel

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Fira Code"
            color: "white"
            text: Qt.formatDateTime(panelBox.datetime, "h:mm AP")
        }
    }
}
