import "./../components"
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Networking

WidgetBox {
    id: panelBox

    property NetworkDevice wifiDevice: Networking.devices.values[0]

    hoverEnabled: true
    implicitWidth: panelLayout.implicitWidth
    bottomRightRadius: 20
    topLeftRadius: 20
    onClicked: mouse => {
        if (mouse.button == Qt.RightButton) {
            if (Networking.wifiEnabled == true)
                Networking.wifiEnabled = false;
            else
                Networking.wifiEnabled = true;
        } else {
            popup.visible = true;
            popup.popupGrab.active = true;
            wifiDevice.scannerEnabled = true;
            scannerTimeout.restart();
        }
    }

    MyRow {
        // MyLabel {
        //     text: wifiDevice.scannerEnabled
        // }

        id: panelLayout

        anchors.verticalCenter: panelBox.verticalCenter

        MyLabel {
            id: panelIcon

            property WifiNetwork connectedNetwork: wifiDevice.networks.values.filter(device => {
                return device.connected;
            })[0]

            text: {
                if (Networking.wifiEnabled) {
                    if (connectedNetwork == undefined) {
                        return "";
                    } else {
                        if (connectedNetwork.signalStrength <= 0.33)
                            return "";
                        else if (connectedNetwork.signalStrength > 0.33 && connectedNetwork.signalStrength <= 0.66)
                            return "";
                        else
                            return "";
                    }
                } else {
                    return "";
                }
            }
            // text: panelLabel.connectedNetwork.signalStrength
            font.family: "Font Awesome 6 Brands"
            anchors.verticalCenter: panelLayout.verticalCenter
            color: Networking.wifiEnabled ? colorDrawer.activeColor : colorDrawer.inactiveColor
        }

        MyLabel {
            id: panelLabel

            font.family: "Fira Code"
            anchors.verticalCenter: panelLayout.verticalCenter
            color: panelIcon.color
            text: {
                if (Networking.wifiEnabled && panelIcon.connectedNetwork != undefined)
                    return panelIcon.connectedNetwork.name;
                else
                    return "";
            }
            // text: connectedNetworks[0] == undefined
            visible: (text == "") ? false : true
        }
    }

    CornerPopup {
        id: popup

        contents: [
            Repeater {
                MenuLabel {
                    id: deviceLabel

                    onClicked: {
                        deviceContextMenu.visible = true;
                        deviceContextMenu.popupGrab.active = true;
                    }
                    font.family: "Fira Code"
                    text: modelData.name
                    color: {
                        if (modelData.connected) {
                            return colorDrawer.activeColor;
                        } else {
                            if (!modelData.connected)
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

                                Connections {
                                    function onConnectionFailed(reason) {
                                        if (reason == ConnectionFailReason.NoSecrets) {
                                            wifiSecrets.visible = true;
                                            wifiSecrets.popupGrab.active = true;
                                            secretInput.clear();
                                            secretInput.focus = true;
                                        } else {}
                                    }

                                    target: modelData
                                }

                                CornerPopup {
                                    id: wifiSecrets

                                    innerBoxImplicitHeight: 50
                                    contents: [
                                        TextField {
                                            id: secretInput

                                            color: colorDrawer.neutralColor
                                            onAccepted: {
                                                wifiSecrets.popupGrab.cleared();
                                                modelData.connectWithPsk(secretInput.text);
                                            }

                                            font {
                                                family: "Fira Code"
                                                pixelSize: 14
                                                bold: true
                                            }

                                            background: Rectangle {
                                                implicitWidth: wifiSecrets.innerBoxImplicitWidth
                                                implicitHeight: wifiSecrets.innerBoxImplicitHeight
                                                color: "transparent"
                                            }

                                            cursorDelegate: Rectangle {
                                                implicitHeight: 10
                                                implicitWidth: 5
                                                color: colorDrawer.activeColor
                                            }
                                        }
                                    ]
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
                                text: "Forget"
                                onClicked: {
                                    modelData.forget();
                                    deviceContextMenu.popupGrab.cleared();
                                }
                            }
                        ]
                    }
                }

                model: ScriptModel {
                    values: wifiDevice.networks.values
                }
            }
        ]
    }

    Timer {
        id: scannerTimeout

        interval: 60000
        onTriggered: {
            wifiDevice.scannerEnabled = false;
        }
    }

    states: State {
        name: "label_hover"
        when: panelBox.widgetMouseArea.containsMouse

        PropertyChanges {
            panelIcon.color: "black"
            panelLabel.color: "black"
        }
    }
}
