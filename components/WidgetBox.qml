import QtQuick

Rectangle {
    id: widgetBox

    property bool hoverEnabled: true
    property alias widgetMouseArea: widgetMouseArea

    signal clicked(mouse: MouseEvent)

    implicitHeight: panel.implicitHeight - 10
    color: "#90000000"

    MouseArea {
        id: widgetMouseArea

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        hoverEnabled: widgetBox.hoverEnabled
        onClicked: mouse => {
            return widgetBox.clicked(mouse);
        }
        onPressed: mouse => {
            if (hoverEnabled)
                return mouse.accepted = true;
            else
                return mouse.accepted = false;
        }
        states: [
            State {
                name: "hover"
                when: (widgetMouseArea.containsMouse && !widgetMouseArea.containsPress)

                PropertyChanges {
                    widgetBox.color: "#90ffffff"
                }
            },
            State {
                name: "press"
                when: (widgetMouseArea.containsMouse && widgetMouseArea.containsPress)

                PropertyChanges {
                    widgetBox.color: "#90FFBF00" // Amber
                }
            }
        ]
    }
}
