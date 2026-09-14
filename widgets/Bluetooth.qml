import "./../components"
import QtQuick
import Quickshell
import Quickshell.Bluetooth

WidgetBox {
    id: panelBox

    hoverEnabled: true
    implicitWidth: panelLayout.implicitWidth
    bottomRightRadius: 20
    topLeftRadius: 20
    onClicked: mouse => {
        if (mouse.button == Qt.RightButton) {
            if (Bluetooth.defaultAdapter.enabled == true)
                Bluetooth.defaultAdapter.enabled = false;
            else
                Bluetooth.defaultAdapter.enabled = true;
        } else {
            popup.visible = true;
            popup.popupGrab.active = true;
        }
    }

    MyRow {
        id: panelLayout

        property var icons: {
            "input-keyboard": "",
            "audio-headset": "",
            "audio-headphones": "",
            "input-mouse": "",
            "phone": "",
            "audio-card": ""
        }
        property list<BluetoothDevice> filteredList: Bluetooth.devices.values.filter(device => {
            return (device.deviceName != "" && device.connected);
        })
        property list<string> mappedIconList: filteredList.map(device => {
            return icons[device.icon];
        })
        property list<string> uniqueIconList: mappedIconList.filter((device, index) => {
            return mappedIconList.indexOf(device) == index;
        })

        anchors.verticalCenter: panelBox.verticalCenter
        MyLabel {
            id: panelIcon

            font.family: "Font Awesome 6 Pro"

            color: Bluetooth.defaultAdapter.enabled ? colorDrawer.activeColor : colorDrawer.inactiveColor
            text: ""
        }

        MyLabel {

            font.family: "Font Awesome 6 Pro"

            color: panelIcon.color
            text: "|"
            visible: (panelLayout.filteredList[0] === undefined) ? false : true
        }

        Repeater {

            model: panelLayout.uniqueIconList

            MyLabel {
                font.family: "Font Awesome 6 Pro"
                color: panelIcon.color

                text: modelData
            }
        }
    }

    Rectangle {
        implicitHeight: panelIcon.implicitHeight + 5
        implicitWidth: 2
        color: panelIcon.color
        anchors.verticalCenter: panelBox.verticalCenter
        x: 15
        visible: !Bluetooth.defaultAdapter.enabled
    }

    CornerPopup {
        id: popup

        contents: [
            Repeater {
                MyRow {
                    // Text {
                    //     text: modelData.icon
                    // }
                    leftPadding: 0

                    Item {
                        implicitHeight: icon.implicitHeight
                        implicitWidth: 30

                        MyLabel {
                            id: icon

                            color: deviceLabel.color
                            font.family: "Font Awesome 6 Pro"
                            text: {
                                if (modelData.icon == [undefined])
                                    return "";
                                else
                                    return panelLayout.icons[modelData.icon];
                            }
                            anchors.centerIn: parent
                        }
                    }

                    MenuLabel {
                        id: deviceLabel

                        anchors.leftMargin: parent.leftMargin
                        onClicked: {
                            deviceContextMenu.visible = true;
                            deviceContextMenu.popupGrab.active = true;
                        }
                        font.family: "Fira Code"
                        text: modelData.deviceName + " (" + Math.round(modelData.battery * 100) + "%)"
                        color: {
                            if (modelData.connected) {
                                return colorDrawer.activeColor;
                            } else {
                                if (modelData.bonded)
                                    return colorDrawer.inactiveColor;
                                else
                                    return "grey";
                            }
                        }

                        CornerPopup {
                            id: deviceContextMenu

                            contents: [
                                MenuLabel {
                                    text: "Connect"
                                    onClicked: {
                                        modelData.connect();
                                        deviceContextMenu.popupGrab.cleared();
                                    }
                                },
                                MenuLabel {
                                    text: "Disconnect"
                                    onClicked: {
                                        modelData.disconnect();
                                        deviceContextMenu.popupGrab.cleared();
                                    }
                                },
                                MenuLabel {
                                    text: "Pair"
                                    onClicked: {
                                        modelData.pair();
                                        deviceContextMenu.popupGrab.cleared();
                                    }
                                },
                                MenuLabel {
                                    text: "Forget"
                                    onClicked: {
                                        modelData.forget();
                                        deviceContextMenu.popupGrab.cleared();
                                    }
                                }
                            ]
                        }
                    }
                }

                model: ScriptModel {
                    values: Bluetooth.devices.values.filter(device => {
                        return device.deviceName != "";
                    })
                }
            }
        ]

        Item {
            states: [
                State {
                    name: "discovering"
                    when: popup.outerBoxImplicitHeight == popup.ultimateImplicitHeight

                    PropertyChanges {
                        restoreEntryValues: false
                        target: Bluetooth.defaultAdapter
                        discovering: true
                    }
                },
                State {
                    name: "undiscovering"
                    when: popup.outerBoxImplicitHeight != popup.ultimateImplicitHeight

                    PropertyChanges {
                        restoreEntryValues: false
                        target: Bluetooth.defaultAdapter
                        discovering: false
                    }
                }
            ]
        }
    }

    states: State {
        name: "label_hover"
        when: panelBox.widgetMouseArea.containsMouse

        PropertyChanges {
            panelIcon.color: "black"
        }
    }
}
