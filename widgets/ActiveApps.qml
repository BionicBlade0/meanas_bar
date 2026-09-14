import "./../components"
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

WidgetBox {
    id: panelBox

    implicitWidth: panelLayout.implicitWidth
    topRightRadius: 20
    bottomLeftRadius: 20
    hoverEnabled: false
    visible: (panelLayout.implicitWidth == 20) ? false : true

    MyRow {
        id: panelLayout

        anchors.verticalCenter: panelBox.verticalCenter

        Repeater {
            model: ToplevelManager.toplevels.values

            IconImage {
                id: panelIcon

                property DesktopEntry activeDesktopEntry: DesktopEntries.applications.values.filter(desktopEntry => {
                    return (desktopEntry.id == modelData.appId);
                })[0]
                implicitSize: 20

                anchors.verticalCenter: panelLayout.verticalCenter
                source: Quickshell.iconPath(activeDesktopEntry.icon)
            }
        }
    }
}
