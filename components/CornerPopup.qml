import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: popupWindow

    property int padding: 15 * panel.scale
    property alias popupGrab: popupGrab
    property alias contents: popupContent.data
    property double ultimateImplicitHeight: popupInnerBox.implicitHeight + (2 * padding)
    property alias outerBoxImplicitHeight: popupOuterBox.implicitHeight
    property alias innerBoxImplicitHeight: popupInnerBox.implicitHeight
    property alias innerBoxImplicitWidth: popupInnerBox.implicitWidth

    focusable: true
    visible: false
    screen: panel.modelData
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell_popup"
    color: "transparent"
    implicitWidth: 400 * panel.scale
    implicitHeight: {
        if (popupOuterBox.implicitHeight < popupWindow.ultimateImplicitHeight)
            return ultimateImplicitHeight;
        else
            return implicitHeight;
    }

    margins {
        top: 10 * panel.scale
        right: 5 * panel.scale
    }

    anchors {
        top: true
        right: true
    }

    Rectangle {
        id: popupOuterBox

        radius: 20 * panel.scale
        color: "#90000000"
        implicitWidth: popupWindow.implicitWidth
        implicitHeight: (popupGrab.active) ? popupWindow.ultimateImplicitHeight : 0
        clip: true

        Rectangle {
            id: popupInnerBox

            implicitWidth: popupWindow.implicitWidth - (2 * popupWindow.padding)
            implicitHeight: popupContent.implicitHeight
            color: "transparent"

            anchors {
                top: parent.top
                right: parent.right
                margins: popupWindow.padding
            }

            Column {
                id: popupContent

                clip: true

                anchors {
                    verticalCenter: popupInnerBox.verticalCenter
                }
            }
        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                onRunningChanged: {
                    if (running == false && popupOuterBox.implicitHeight == 0)
                        popupWindow.visible = false;
                }
            }
        }
    }

    HyprlandFocusGrab {
        id: popupGrab

        windows: [popupWindow]
        onCleared: {
            active = false;
        }
    }
}
