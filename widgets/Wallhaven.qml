import "./../components"
import QtQuick
import QtQuick.Controls
import Quickshell.Io

WidgetBox {
    id: panelBox

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton) {
            popup.visible = true;
            popup.popupGrab.active = true;
            searchField.focus = true;
        }
    }
    hoverEnabled: true
    implicitWidth: panelLayout.implicitWidth
    bottomRightRadius: 20
    topLeftRadius: 20

    MyRow {
        id: panelLayout
        anchors.verticalCenter: panelBox.verticalCenter

        MyLabel {
            id: panelIcon

            text: ""
            font.family: "Font Awesome 6 Pro"
            anchors.verticalCenter: panelLayout.verticalCenter
        }
    }

    Popup {
        id: popup

        contents: [
            Column {
                id: outerLayout

                anchors.horizontalCenter: popup.popupOuterBox.horizontalCenter

                Row {
                    MyTextField {
                        id: searchField

                        placeholderText: "anime"
                        placeholderTextColor: "white"
                        implicitWidth: thumbnailBox.implicitWidth - previousPage.implicitWidth - pageField.implicitWidth - lastPage.implicitWidth - nextPage.implicitWidth
                    }

                    Navigation {
                        id: previousPage

                        text: "==>"
                        rotation: 180
                        onClicked: mouse => {
                            if (mouse.button == Qt.LeftButton) {
                                if (Number(pageField.text) > 1) {
                                    pageField.text = Number(pageField.text) - 1;
                                    thumbnails.running = true;
                                }
                            }
                        }
                    }

                    MyTextField {
                        id: pageField

                        text: "1"
                        horizontalAlignment: TextInput.AlignHCenter
                    }

                    Text {
                        id: lastPage

                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"

                        font {
                            family: "Fira Code"
                            pixelSize: 25
                        }
                    }

                    Navigation {
                        id: nextPage

                        text: "==>"
                        onClicked: mouse => {
                            if (mouse.button == Qt.LeftButton) {
                                pageField.text = Number(pageField.text) + 1;
                                thumbnails.running = true;
                            }
                        }
                    }
                }

                Rectangle {
                    id: thumbnailBox

                    color: "transparent"
                    implicitHeight: popup.implicitHeight - searchField.implicitHeight - 20
                    implicitWidth: popup.implicitWidth - 40
                    clip: true

                    GridView {
                        id: thumbnailLayout

                        cellWidth: thumbnailBox.implicitWidth / 3
                        cellHeight: 200
                        anchors.fill: thumbnailBox

                        delegate: Rectangle {
                            id: thumbnail

                            radius: 20
                            clip: true
                            color: "transparent"
                            implicitHeight: thumbnailLayout.cellHeight
                            implicitWidth: thumbnailLayout.cellWidth

                            Image {
                                id: image

                                property list<string> splitted: modelData.split("|")
                                property string thumb_url: splitted[0]
                                property string path: splitted[1]

                                fillMode: Image.PreserveAspectCrop
                                source: thumb_url
                                anchors.fill: thumbnail

                                MouseArea {
                                    id: widgetMouseArea

                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    anchors.fill: parent
                                    onClicked: mouse => {
                                        if (mouse.button == Qt.LeftButton) {
                                            popup.popupGrab.cleared();
                                            wallpaper.command = ["/mnt/hiroshi/hyprland_dotfiles/_hyprland_env/bin/python", "/mnt/hiroshi/hyprland_dotfiles/_quickshell_bar/wallhaven/wallpaper.py", image.path];
                                            wallpaper.running = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        ]
    }

    component Navigation: Text {
        id: navigation

        signal clicked(mouse: MouseEvent)

        anchors.verticalCenter: parent.verticalCenter
        color: "white"

        font {
            family: "Fira Code"
            pixelSize: 25
        }

        MouseArea {
            id: mouseArea

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: navigation
            hoverEnabled: true
            onClicked: mouse => {
                return navigation.clicked(mouse);
            }

            states: State {
                name: "hover"
                when: (mouseArea.containsMouse)

                PropertyChanges {
                    navigation.color: colorDrawer.neutralColor
                    navigation.font.bold: true
                }
            }
        }
    }

    Process {
        id: thumbnails

        command: ["/mnt/hiroshi/hyprland_dotfiles/_quickshell_bar/wallhaven/thumbnails", "https://wallhaven.cc/api/v1/search?sorting=relevance&q=" + searchField.text + "&page=" + pageField.text]
        onStarted: {
            thumbnailLayout.model = "";
        }

        stdout: StdioCollector {
            onStreamFinished: {
                let splitted = text.split("|||");
                lastPage.text = "/" + splitted[1];
                thumbnailLayout.model = splitted[0].split("||");
            }
        }
    }

    Process {
        id: wallpaper
    }

    states: State {
        name: "label_hover"
        when: panelBox.widgetMouseArea.containsMouse

        PropertyChanges {
            panelIcon.color: "black"
        }
    }
}
