import "./../components"
import QtQuick

WidgetBox {
    id: panelBox

    property var datetime

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20
    bottomLeftRadius: 20
    hoverEnabled: false

    MyRow {
        id: panelLayout

        anchors.verticalCenter: panelBox.verticalCenter

        MyLabel {
            id: panelIcon

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Font Awesome 6 Brands"
            color: "white"
            text: ""
        }

        MyLabel {
            id: panelLabel

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Fira Code"
            color: "white"
            text: Qt.formatDateTime(panelBox.datetime, "MMM dd, yyyy")
        }
    }
}
