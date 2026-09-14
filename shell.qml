import "./components"
import "./widgets"
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            // Item {
            // // put centerPanel inside this Item if centerPanel needs to be at the center of leftPanel and rightPanel
            //     x: leftPanel.width
            //     implicitWidth: parent.width - leftPanel.width - rightPanel.width - rightPanel.anchors.rightMargin
            //     implicitHeight: parent.height
            // }

            id: panel

            required property var modelData

            WlrLayershell.layer: WlrLayer.Bottom
            screen: modelData
            color: "transparent"
            implicitHeight: 45

            anchors {
                top: true
                left: true
                right: true
            }

            ColorDrawer {
                id: colorDrawer
            }

            Row {
                id: leftPanel

                spacing: 5
                layoutDirection: Qt.LeftToRight

                anchors {
                    leftMargin: 5
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                BatteryLevel {}

                Brightness {}

                Temperature {}

                Weather {}

                ActiveApps {}
            }

            Row {
                id: centerPanel

                // parent is NOT panel
                anchors.centerIn: parent
                layoutDirection: Qt.LeftToRight
                spacing: 50

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                Date {
                    datetime: systemClock.date
                }

                Workspace {}

                Clock {
                    datetime: systemClock.date
                }
            }

            Row {
                id: rightPanel

                spacing: 5
                layoutDirection: Qt.RightToLeft

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 5
                }

                Power {}

                PowerProfile {}

                Volume {}

                Bluetooth {}

                Network {}

                Wallhaven {}

                Apps {}
            }
        }
    }

    SystemClock {
        id: systemClock

        precision: SystemClock.Minutes
    }
}
