import "./../components"
import QtQuick
import Quickshell.Hyprland

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20 * panel.scale
    topLeftRadius: 20 * panel.scale
    hoverEnabled: false

    MyRow {
        // MyLabel {
        //     text: panelIcon.rotation
        // }

        id: panelLayout
        spacing: 0

        WidgetBox {
            id: panelIconBox

            anchors.verticalCenter: panelLayout.verticalCenter
            topLeftRadius: 20 * panel.scale
            topRightRadius: 20 * panel.scale
            implicitWidth: panelIcon.implicitWidth + (30 * panel.scale)
            color: "transparent"
            hoverEnabled: true
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton)
                    Hyprland.dispatch("hl.dsp.focus({ workspace = 'empty' })");
            }

            MyLabel {
                id: panelIcon

                property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace

                font.family: "Font Awesome 6 Pro"
                font.pixelSize: 20 * panel.scale
                text: ""
                anchors.centerIn: panelIconBox
                rotation: 0

                onFocusedWorkspaceChanged: {
                    if (!animation.running)
                        rotation = rotation + 180;
                }

                Behavior on rotation {
                    NumberAnimation {
                        id: animation

                        duration: 200
                    }
                }

                states: State {
                    name: "label_hover"
                    when: panelIconBox.widgetMouseArea.containsMouse

                    PropertyChanges {
                        panelIcon.color: "black"
                    }
                }
            }
        }

        Repeater {
            model: Hyprland.workspaces

            WidgetBox {
                id: workspaceBox

                anchors.verticalCenter: panelLayout.verticalCenter
                topLeftRadius: 20 * panel.scale
                topRightRadius: 20 * panel.scale
                implicitWidth: workspaceLabel.implicitWidth + (30 * panel.scale)
                color: "transparent"
                onClicked: mouse => {
                    if (mouse.button == Qt.LeftButton)
                        Hyprland.dispatch("hl.dsp.focus({ workspace = '" + modelData.id + "' })");
                }

                MyLabel {
                    id: workspaceLabel

                    font.family: "Fira Code"
                    color: {
                        if (panelBox.implicitWidth != panelLayout.implicitWidth) {
                            return "transparent";
                        } else {
                            if (modelData.focused)
                                return colorDrawer.activeColor;
                            else
                                return "white";
                        }
                    }
                    text: modelData.id
                    anchors.centerIn: workspaceBox

                    states: State {
                        name: "label_hover"
                        when: workspaceBox.widgetMouseArea.containsMouse

                        PropertyChanges {
                            workspaceLabel.color: "black"
                        }
                    }
                }
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
        }
    }
}
