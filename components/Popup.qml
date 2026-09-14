import "./../components"
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: popupWindow

    property alias popupGrab: popupGrab
    property alias contents: popupOuterBox.data
    property alias popupOuterBox: popupOuterBox

    visible: false
    WlrLayershell.namespace: "quickshell_popup"
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    screen: panel.modelData
    implicitWidth: panel.modelData.width / 2
    implicitHeight: panel.modelData.height / 2
    color: "transparent"
    anchors.bottom: true
    margins.bottom: (panel.modelData.height / 2) - (popupWindow.implicitHeight / 2)

    Rectangle {
        id: popupOuterBox

        color: "#90000000"
        implicitWidth: popupWindow.implicitWidth
        implicitHeight: (popupGrab.active) ? popupWindow.implicitHeight : 0
        clip: true
        radius: 20 * panel.scale

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
