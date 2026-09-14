import "./../components"
import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    bottomRightRadius: 20 * panel.scale
    topLeftRadius: 20 * panel.scale
    hoverEnabled: true
    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton) {
            popup.visible = true;
            popup.popupGrab.active = true;
        }
    }

    MyRow {
        id: panelLayout

        anchors.verticalCenter: panelBox.verticalCenter

        MyLabel {
            id: volumeIcon

            anchors.verticalCenter: panelLayout.verticalCenter
            color: volumeLabel.color
            text: (volumeLabel.speaker.audio.muted) ? "" : ""
            font.family: "Font Awesome 6 Pro"
        }

        MyLabel {
            id: volumeLabel

            property PwNode speaker: Pipewire.defaultAudioSink
            property int realVol: Math.round(speaker.audio.volume * 100)
            property int vol: Math.min(realVol, 100)

            anchors.verticalCenter: panelLayout.verticalCenter
            color: colorDrawer.generalGradient[vol]
            text: realVol + "%"
            font.family: "Fira Code"

            PwObjectTracker {
                objects: [volumeLabel.speaker]
            }
        }

        MyLabel {
            id: microphoneIcon

            anchors.verticalCenter: panelLayout.verticalCenter
            color: microphoneLabel.color
            text: (microphoneLabel.microphone.audio.muted) ? "" : ""
            font.family: "Font Awesome 6 Pro"
        }

        MyLabel {
            id: microphoneLabel

            property PwNode microphone: Pipewire.defaultAudioSource
            property int vol: Math.min(Math.round(microphone.audio.volume * 100), 100)

            anchors.verticalCenter: panelLayout.verticalCenter
            color: colorDrawer.generalGradient[vol]
            text: vol + "%"
            font.family: "Fira Code"

            PwObjectTracker {
                objects: [microphoneLabel.microphone]
            }
        }

        CornerPopup {
            id: popup

            contents: [
                MyLabel {
                    text: "Controls"

                    font {
                        family: "Fira Code"
                        underline: true
                    }
                },
                MyRow {
                    id: volumeControl
                    spacing: 30 * panel.scale

                    MenuLabel {
                        text: volumeIcon.text
                        anchors.verticalCenter: volumeControl.verticalCenter
                        onClicked: mute.exec(mute)
                    }

                    MenuLabel {
                        text: "+++"
                        anchors.verticalCenter: volumeControl.verticalCenter
                        onClicked: increaseVolume.exec(increaseVolume)
                    }

                    MenuLabel {
                        text: "-----"
                        anchors.verticalCenter: volumeControl.verticalCenter
                        onClicked: decreaseVolume.exec(decreaseVolume)
                    }
                },
                // MyLabel {
                //     text: " "
                // },
                // MyLabel {
                //     text: "Output"

                //     font {
                //         family: "Fira Code"
                //         underline: true
                //     }
                // },
                // Repeater {
                //     model: Pipewire.nodes

                //     MenuLabel {
                //         id: volumeSinksLabel

                //         onClicked: Pipewire.preferredDefaultAudioSink = modelData
                //         leftPadding: 10
                //         font.family: "Fira Code"
                //         text: modelData.description
                //         color: (modelData == Pipewire.defaultAudioSink) ? colorDrawer.activeColor : "white"
                //     }
                // },
                MyLabel {
                    text: " "
                },
                MyLabel {
                    text: "Speakers"

                    font {
                        family: "Fira Code"
                        underline: true
                    }
                },
                Repeater {
                    model: Pipewire.nodes.values.filter(node => {
                        return (node.isSink && !node.isStream);
                    })

                    MenuLabel {
                        id: volumeSinksLabel

                        onClicked: Pipewire.preferredDefaultAudioSink = modelData
                        leftPadding: 10 * panel.scale
                        font.family: "Fira Code"
                        text: modelData.description
                        color: (modelData == Pipewire.defaultAudioSink) ? colorDrawer.activeColor : "white"
                    }
                },
                // MyLabel {
                //     text: ""

                //     font {
                //         family: "Fira Code"
                //         underline: true
                //     }
                // },
                MyLabel {
                    text: " "
                },
                MyLabel {
                    text: "Microphones"

                    font {
                        family: "Fira Code"
                        underline: true
                    }
                },
                Repeater {
                    model: Pipewire.nodes.values.filter(node => {
                        return (!node.isSink && node.audio);
                    })

                    MenuLabel {
                        id: volumeSourcesLabel

                        onClicked: Pipewire.preferredDefaultAudioSource = modelData
                        leftPadding: 10 * panel.scale
                        font.family: "Fira Code"
                        text: modelData.description
                        color: (modelData == Pipewire.defaultAudioSource) ? colorDrawer.activeColor : "white"
                    }
                }
            ]

            Process {
                id: increaseVolume

                command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]
            }

            Process {
                id: decreaseVolume

                command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
            }

            Process {
                id: mute

                command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
            }
        }
    }

    DataDisplay {
        icon: volumeIcon.text
        text: volumeLabel.text
        fontColor: volumeLabel.color
    }

    states: State {
        name: "label_hover"
        when: panelBox.widgetMouseArea.containsMouse

        PropertyChanges {
            volumeIcon.color: "black"
            volumeLabel.color: "black"
            microphoneIcon.color: "black"
            microphoneLabel.color: "black"
        }
    }
}
