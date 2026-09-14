import "./../components"
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20
    bottomLeftRadius: 20
    hoverEnabled: false
    visible: (panelLayout.implicitWidth == 20) ? false : true

    Row {
        id: panelLayout

        spacing: 10
        leftPadding: 10
        rightPadding: 10
        anchors.verticalCenter: panelBox.verticalCenter

        Repeater {
            model: ToplevelManager.toplevels.values

            Rectangle {
                implicitWidth: panelIcon.implicitWidth + workspaceBox.implicitWidth
                implicitHeight: panelBox.implicitHeight
                color: "transparent"

                IconImage {
                    id: panelIcon

                    anchors.centerIn: parent
                    property DesktopEntry activeDesktopEntry: DesktopEntries.applications.values.filter(desktopEntry => {
                        return (desktopEntry.id == modelData.appId);
                    })[0]
                    implicitSize: 20

                    anchors.verticalCenter: parent.verticalCenter
                    source: Quickshell.iconPath(activeDesktopEntry.icon)
                }
                Rectangle {
                    id: workspaceBox
                    implicitWidth: implicitHeight
                    implicitHeight: workspaceLabel.implicitHeight
                    // implicitHeight: 50

                    color: "white"
                    radius: implicitHeight

                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                    }
                    Text {
                        id: workspaceLabel

                        property HyprlandToplevel hyprlandToplevel: Hyprland.toplevels.values.filter(toplevel => {
                            return (toplevel.title.includes(panelIcon.activeDesktopEntry.name));
                        })[0]

                        text: hyprlandToplevel.workspace.id
                        anchors.centerIn: workspaceBox
                        font.family: "Fira Code"
                    }
                }
            }
        }
    }
}
