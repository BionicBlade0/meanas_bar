import "./../components"
import QtQuick
import Quickshell.Services.UPower

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20 * panel.scale
    bottomLeftRadius: 20 * panel.scale
    hoverEnabled: false

    MyRow {
        id: panelLayout

        property UPowerDevice device: UPower.devices.values[0]
        property int charge: Math.round(panelLayout.device.percentage * 100)

        anchors {
            right: panelBox.right
            verticalCenter: panelBox.verticalCenter
        }

        MyLabel {
            id: panelIcon

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Font Awesome 6 Brands"
            color: panelLabel.color
            text: {
                if (panelLayout.device.state == UPowerDeviceState.Charging || panelLayout.device.state == UPowerDeviceState.FullyCharged) {
                    return "";
                } else {
                    if (panelLayout.charge <= 5)
                        return "";

                    if (panelLayout.charge > 5 && panelLayout.charge <= 35)
                        return "";

                    if (panelLayout.charge > 35 && panelLayout.charge <= 65)
                        return "";

                    if (panelLayout.charge > 65 && panelLayout.charge <= 95)
                        return "";

                    if (panelLayout.charge > 95)
                        return "";
                }
            }
        }

        MyLabel {
            id: panelLabel

            anchors.verticalCenter: panelLayout.verticalCenter
            font.family: "Fira Code"
            text: panelLayout.charge + "%"
            color: colorDrawer.generalGradient[100 - panelLayout.charge]
        }
    }
}
