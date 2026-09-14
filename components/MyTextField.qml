import QtQuick
import QtQuick.Controls

TextField {
    activeFocusOnPress: true
    color: {
        if (focus)
            return colorDrawer.neutralColor;
        else
            return "white";
    }
    implicitHeight: 45
    onAccepted: {
        if (searchField.focus) {
            pageField.text = "1";
            lastPage.text = "";
        }
        thumbnails.running = true;
    }

    font {
        family: "Fira Code"
        pixelSize: 25
    }

    background: Rectangle {
        color: "transparent"
    }
}
