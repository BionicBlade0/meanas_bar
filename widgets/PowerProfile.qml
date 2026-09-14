import "./../components"
import QtQuick
import Quickshell.Services.UPower

WidgetBox {
    id: panelBox

    property ProfileBox activeProfile: {
        if (PowerProfiles.profile == PowerProfiles.PowerSaver) {
            return powerSaver;
        } else {
            if (PowerProfiles.profile == PowerProfiles.Balanced)
                return balanced;
            else
                return performance;
        }
    }

    implicitWidth: activeProfile.implicitWidth
    bottomRightRadius: 20 * panel.scale
    topLeftRadius: 20 * panel.scale

    Item {
        states: [
            State {
                name: "powerSaverVisibility"
                when: panelLayout.spacing == -activeProfile.implicitWidth && PowerProfiles.profile == PowerProfiles.PowerSaver

                PropertyChanges {
                    balanced.visible: false
                    performance.visible: false
                }
            },
            State {
                name: "balancedVisibility"
                when: panelLayout.spacing == -activeProfile.implicitWidth && PowerProfiles.profile == PowerProfiles.Balanced

                PropertyChanges {
                    powerSaver.visible: false
                    performance.visible: false
                }
            },
            State {
                name: "performanceVisibility"
                when: panelLayout.spacing == -activeProfile.implicitWidth && PowerProfiles.profile == PowerProfiles.Performance

                PropertyChanges {
                    powerSaver.visible: false
                    balanced.visible: false
                }
            }
        ]
    }

    Item {
        transitions: [
            Transition {
                reversible: true

                NumberAnimation {
                    properties: "implicitWidth,panelLayout.spacing"
                    duration: 200
                }
            }
        ]

        states: State {
            name: "hover"
            when: hoverHandler.hovered

            PropertyChanges {
                panelLayout.spacing: 0
                panelBox.implicitWidth: powerSaver.implicitWidth + balanced.implicitWidth + performance.implicitWidth
            }
        }
    }

    Row {
        id: panelLayout

        width: panelBox.width
        spacing: -activeProfile.implicitWidth
        layoutDirection: Qt.RightToLeft

        ProfileBox {
            id: powerSaver

            anchors.verticalCenter: panelLayout.verticalCenter
            labelColor: (PowerProfiles.profile == PowerProfiles.PowerSaver) ? colorDrawer.neutralColor : "white"
            text: ""
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton)
                    PowerProfiles.profile = PowerProfiles.PowerSaver;
            }
        }

        ProfileBox {
            id: balanced

            anchors.verticalCenter: panelLayout.verticalCenter
            labelColor: (PowerProfiles.profile == PowerProfiles.Balanced) ? colorDrawer.activeColor : "white"
            text: ""
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton)
                    PowerProfiles.profile = PowerProfiles.Balanced;
            }
        }

        ProfileBox {
            id: performance

            anchors.verticalCenter: panelLayout.verticalCenter
            labelColor: (PowerProfiles.profile == PowerProfiles.Performance) ? colorDrawer.inactiveColor : "white"
            text: ""
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton)
                    PowerProfiles.profile = PowerProfiles.Performance;
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    component ProfileBox: WidgetBox {
        id: widgetBox

        property alias text: powerLabel.text
        property alias labelColor: powerLabel.color

        implicitWidth: powerLabel.implicitWidth
        color: "transparent"
        bottomRightRadius: 20 * panel.scale
        topLeftRadius: 20 * panel.scale

        MyLabel {
            id: powerLabel

            leftPadding: 10 * panel.scale
            rightPadding: 10 * panel.scale
            anchors.centerIn: parent
            font.family: "Font Awesome 6 Brands"
        }

        states: State {
            name: "label_hover"
            when: widgetBox.widgetMouseArea.containsMouse

            PropertyChanges {
                powerLabel.color: "black"
            }
        }
    }
}
