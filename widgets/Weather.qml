import "./../components"
import QtQuick
import Quickshell.Io

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20 * panel.scale
    bottomLeftRadius: 20 * panel.scale
    hoverEnabled: false

    MyRow {
        id: panelLayout
        anchors.verticalCenter: panelBox.verticalCenter

        MyLabel {
            id: weatherLabel

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Fira Code"
        }
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: getWeather.running = true
    }

    Process {
        id: getWeather

        command: ["/mnt/hiroshi/Development/hyprland_dotfiles/_hyprland_env/bin/python", "/mnt/hiroshi/Development/meanas_bar/weather/weather.py"]

        stdout: StdioCollector {
            onStreamFinished: {
                weatherLabel.text = text;
            }
        }
    }
}
