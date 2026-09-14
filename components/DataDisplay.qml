import "./../components"
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: dataWindow

    property alias text: dataLabel.text
    property alias icon: dataIcon.text
    property alias fontColor: dataIcon.color

    implicitWidth: dataLayout.implicitWidth + (20 * panel.scale)
    implicitHeight: dataLayout.implicitHeight + (20 * panel.scale)
    screen: panel.modelData
    color: "transparent"
    anchors.bottom: true
    margins.bottom: 10 * panel.scale
    WlrLayershell.namespace: "quickshell_popup"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    Rectangle {
        implicitWidth: dataWindow.implicitWidth
        implicitHeight: dataWindow.implicitHeight
        color: "#90000000"
        radius: 20 * panel.scale

        MyRow {
            id: dataLayout

            anchors.centerIn: parent

            MyLabel {
                id: dataIcon

                anchors.verticalCenter: dataLayout.verticalCenter
                font.pixelSize: 25 * panel.scale
                font.family: "Font Awesome 6 Pro"
                onTextChanged: {
                    dataWindow.visible = true;
                    timer.restart();
                }
            }

            MyLabel {
                id: dataLabel

                anchors.verticalCenter: dataLayout.verticalCenter
                font.pixelSize: 25 * panel.scale
                color: dataIcon.color
                onTextChanged: {
                    dataWindow.visible = true;
                    timer.restart();
                }
            }
        }
    }

    Timer {
        id: timer

        interval: 2000
        onTriggered: dataWindow.visible = false
    }
}
