/****************************************************************************
**
** Copyright (C) 2018 TurtleCoin Developers & Contributors.
**
** This file is part of TurtleBuchet
**
** TurtleBuchet is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** TurtleBuchet is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with TurtleBuchet.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.11
import Qt.labs.settings 1.0

Item {
    id: launcherTab
    width: 580
    height: 400
    SystemPalette {
        id: palette
    }
    clip: true


    property string processState: "stopped"
    property string daemonName: "TurtleCoind"
    property bool dialogDirmode: false

    function getDirName(isDaemon) {
        if(!isDaemon){
            if(settings.dataDir.length) return settings.dataDir
            return ""
        }

        if(settings.daemonPath.length){
            var re = new RegExp(/TurtleCoind?(\.*)$/)
            return settings.daemonPath.replace(re, '')
        }
        return "TurtleCoind"
    }

    function isAddressValid(addr) {
        addr = addr || settings.feeAddress
        var re = new RegExp(/^TRTL(?=[aA-zZ0-9]*$)(?:.{95}|.{183})$/)
        return re.test(addr)
    }

    function argumentError() {
        if (settings.feeAmount > 0 && !isAddressValid()) {
            return "Please enter a valid TRTL address, or set fee amount to 0"
        }
        return ""
    }

    FileDialog {
        id: daemonPathFileDialog
        visible: false
        title: "Select TurtleCoind executable"
        nameFilters: ["TurtleCoin Daemon Executable (TurtleCoind TurtleCoind*exe)"]
        selectedNameFilter: "TurtleCoin Daemon Executable (TurtleCoind TurtleCoind*exe)"
        selectFolder: false
        selectExisting: true
        selectMultiple: false
        sidebarVisible: true
        modality: Qt.WindowModal
        folder: getDirName(true)
        onAccepted: {
            daemonPath.text = fileUrl.toString()
        }
        onRejected: {
        }
    }

    FileDialog {
           id: dbPathFileDialog
           title: "Select directory to store the blockchain data..."
           nameFilters: "[All Files (*)]"
           selectedNameFilter: "All Files (*)"
           selectFolder: true
           visible: false
           modality: Qt.WindowModal
           selectExisting: true
           selectMultiple: false
           sidebarVisible: true
           folder: getDirName(false)
           onAccepted: {
               dataDirectory.text = fileUrl.toString()
           }
           onRejected: {
           }
       }



    ScrollView {
        id: starterScrollView
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: bottomBar.top
            leftMargin: 12
            rightMargin: 12
        }

        ColumnLayout {
            anchors.top: parent.top
            spacing: 8
            Item {
                Layout.preferredHeight: 4
            }

            Label {
                text: "TurtleCoind executable path:"
                Layout.alignment: Qt.AlignBaseline
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                TextField {
                    id: daemonPath
                    Layout.alignment: Qt.AlignBaseline
                    text: settings.daemonPath
                    Layout.minimumWidth: (launcherTab.width / 2)
                    Layout.preferredWidth: (launcherTab.width / 1.275)
                    Layout.fillWidth: true
                    readOnly: true
                    onTextChanged: {
                        settings.daemonPath = text
                    }
                }

                Button {
                    id: changeDaemonPath
                    text: "Change..."
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        daemonPathFileDialog.open()
                    }
                }
            }

            Label {
                text: "Data directory:"
                Layout.alignment: Qt.AlignBaseline
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                TextField {
                    id: dataDirectory
                    Layout.alignment: Qt.AlignBaseline
                    text: settings.dataDir
                    Layout.minimumWidth: (launcherTab.width / 2)
                    Layout.preferredWidth: (launcherTab.width / 1.275)
                    Layout.fillWidth: true
                    readOnly: true
                    placeholderText: "Leave blank to use default path"
                    onTextChanged: {
                        settings.dataDir = text
                    }
                }

                Button {
                    id: changeDatadir
                    text: "Change..."
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        dbPathFileDialog.open()
                    }
                }

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Label {
                    text: "Fee Address: "
                    Layout.alignment: Qt.AlignBaseline
                }

                TextField {
                    id: nodeFeeAddress
                    text: settings.feeAddress
                    Layout.fillWidth: true
                    placeholderText: "TRTL..."
                    validator: RegExpValidator{ regExp: /^TRTL(?=[aA-zZ0-9]*$)(?:.{95}|.{183})$/ }
                    onTextEdited: {
                        settings.feeAddress = qsTr(text)
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Label {
                    text: "Fee Amount: "
                    Layout.alignment: Qt.AlignBaseline
                }

                SpinBox{
                    id: nodeFeeAmount
                    value: settings.feeAmount
                    from: 0
                    to: 100 * 10000
                    stepSize: 100
                    editable: true

                    property int decimals: 2
                    property real realValue: value/100
                    validator: DoubleValidator {
                        bottom: Math.min(nodeFeeAmount.from, nodeFeeAmount.to)
                        top:  Math.max(nodeFeeAmount.from, nodeFeeAmount.to)
                    }
                    onValueChanged: {
                        settings.feeAmount = value
                    }
                    textFromValue: function(value, locale) {
                            return Number(value / 100).toLocaleString(locale, 'f', nodeFeeAmount.decimals)
                    }

                    valueFromText: function(text, locale) {
                        return Number.fromLocaleString(locale, text) * 100
                    }
                }
            }
        }
    }

    Rectangle {
        id: bottomBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            //bottomMargin: statusBarText.height + 12

        }
        height: buttonRow.height * 1.2
        color: Qt.darker(palette.window, 1.1)
        border.color: Qt.darker(palette.window, 1.3)

        Row {
            id: buttonRow
            spacing: 6
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            height: implicitHeight
            width: parent.width
            layoutDirection: Qt.RightToLeft

            state: processState
            states: [
                State {
                    name: 'started'
                    PropertyChanges{
                            target: launcherButton
                            enabled: false
                    }
                    PropertyChanges {
                        target: launcherStopButton
                        enabled: true
                    }
                },
                State{
                    name: 'stopped'
                    PropertyChanges {
                        target: launcherButton
                        enabled: true
                    }
                    PropertyChanges {
                        target: launcherStopButton
                        enabled: false
                    }
                },
                State{
                    name: 'finished'
                    PropertyChanges {
                        target: launcherButton
                        enabled: true
                    }
                    PropertyChanges {
                        target: launcherStopButton
                        enabled: false
                    }
                }
            ]

            Button {
                id: launcherStopButton
                text: "STOP"
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    launcherStopButton.enabled = false
                    syncInfoTimer.stop()
                    daemonStopRequested = true
                    // wait for syncstatus requests clear
                    delay(3100, function(){
                        statusText = "Stopping daemon, may took a while to complete, please be patient..."
                        daemonLauncher.stop()
                        delayTimer.stop()
                        // todo: kill if daemon stuck/took too long to stop
                    })
                }
            }

            Button {
                id: launcherButton
                text: "START"
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    statusText = "Starting daemon..."
                    launcherButton.enabled = false
                    var err = argumentError()
                    if (err.length) {
                        messageDialog.text = err
                        messageDialog.visible = true
                        launcherButton.enabled = true
                    } else {
                        //var args = ["--dump-config"]
                        var args = []
                        if(settings.feeAmount > 0){
                            args.push("--fee-amount")
                            args.push(settings.feeAmount)
                            args.push("--fee-address")
                            args.push(settings.feeAddress)
                        }

                        if(settings.dataDir.length){
                            args.push("--data-dir")
                            args.push(settings.dataDir)
                        }

                        if(settings.p2pBindIp.length){
                            args.push("--p2p-bind-ip")
                            args.push(settings.p2pBindIp)
                        }

                        if(settings.p2pBindPort > 0){
                            args.push("--p2p-bind-port")
                            args.push(settings.p2pBindPort)
                        }

                        if(settings.p2pExternalPort > 0){
                            args.push("--p2p-external-port")
                            args.push(settings.p2pExternalPort)
                        }

                        if(settings.rpcBindIp.length){
                            args.push("--rpc-bind-ip")
                            args.push(settings.rpcBindIp)
                        }

                        if(settings.rpcBindPort > 0){
                            args.push("--rpc-bind-port")
                            args.push(settings.rpcBindPort)
                        }

                        daemonLauncher.arguments = args
                        daemonLauncher.launch()
                    }

                    launcherButton.focus = false
                }
            }
        }
    }
}
