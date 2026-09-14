import QtQuick

MyLabel {
    id: label

    property alias mouseArea: mouseArea

    signal clicked

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent
        onClicked: label.clicked()
    }

    states: State {
        name: "hover"
        when: mouseArea.containsMouse

        PropertyChanges {
            label.color: colorDrawer.neutralColor
        }
    }
}
