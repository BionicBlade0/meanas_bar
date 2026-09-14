import "./../components"
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

WidgetBox {
    id: panelBox

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton) {
            searchField.text = "";
            popup.visible = true;
            popup.popupGrab.active = true;
            searchField.focus = true;
        }
    }
    hoverEnabled: true
    implicitWidth: panelLayout.implicitWidth
    bottomRightRadius: 20 * panel.scale
    topLeftRadius: 20 * panel.scale

    MyRow {
        id: panelLayout
        anchors.verticalCenter: panelBox.verticalCenter
        MyLabel {
            id: panelIcon

            font.family: "Font Awesome 6 Pro"
            anchors.verticalCenter: panelLayout.verticalCenter
            text: ""
        }
    }

    Popup {
        id: popup

        contents: [
            Column {
                id: outerLayout

                anchors.horizontalCenter: popup.popupOuterBox.horizontalCenter

                MyTextField {
                    id: searchField

                    // activeFocusOnTab: true
                    implicitWidth: menuBox.implicitWidth
                }

                Rectangle {
                    id: menuBox

                    color: "transparent"
                    implicitHeight: popup.implicitHeight - searchField.implicitHeight - (20 * panel.scale)
                    implicitWidth: popup.implicitWidth - (40 * panel.scale)
                    clip: true

                    GridView {
                        id: menuLayout

                        property list<DesktopEntry> listApps: DesktopEntries.applications.values
                        property var filListApps: listApps.filter(element => {
                            return element.name.toLowerCase().match(searchField.text.toLowerCase());
                        })

                        cellWidth: menuBox.implicitWidth / 2
                        cellHeight: 40 * panel.scale
                        model: filListApps.sort((a, b) => {
                            return a.name.localeCompare(b.name);
                        })
                        anchors.fill: menuBox

                        delegate: Rectangle {
                            color: "transparent"
                            implicitWidth: menuLayout.cellWidth - (20 * panel.scale)
                            implicitHeight: menuLayout.cellHeight
                            clip: true

                            Row {
                                spacing: 10 * panel.scale
                                Rectangle {
                                    id: iconBox

                                    anchors.verticalCenter: parent.verticalCenter
                                    implicitWidth: 35 * panel.scale
                                    implicitHeight: implicitWidth
                                    color: "transparent"

                                    Image {
                                        source: {
                                            Quickshell.iconPath(modelData.icon);
                                        }
                                        sourceSize: Qt.size(iconBox.implicitWidth, iconBox.implicitWidth)
                                        anchors.fill: iconBox
                                    }
                                }

                                MenuLabel {
                                    onClicked: {
                                        popup.popupGrab.cleared();
                                        modelData.execute();
                                    }
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.family: "Fira Code"
                                    font.pixelSize: 25 * panel.scale
                                    text: modelData.name
                                }
                            }
                        }
                    }
                }
            }
        ]
    }

    states: State {
        name: "label_hover"
        when: panelBox.widgetMouseArea.containsMouse

        PropertyChanges {
            panelIcon.color: "black"
        }
    }
}
