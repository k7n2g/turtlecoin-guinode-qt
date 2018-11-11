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
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

import Launcher 1.0

ApplicationWindow {
    id: turtleBuchet
    visible: true
    title: "TurtleBuchet - TurtleCoind Launcher"
    width: 640
    height: 420
    minimumWidth: 640
    minimumHeight: 420

    onClosing: {
        close.accepted = false
        if(dstate !== "started"){
            close.accepted = true
            Qt.quit()
        }
        daemonStopRequested = true
        quitConfirmDialog.open()
    }

    SystemPalette {
        id: winpalette
    }

    property string logOutput: "Daemon is not running."

    property string dstate: "stopped"
    property bool daemonStopRequested: false
    property bool appQuitRequested: false
    property string statusText: "Idle"


    function getSyncInfo()
    {
        var statusLine = ""
        var xhr = new XMLHttpRequest()
        if(daemonStopRequested){
            try{xhr.abort()}catch(e){}
            return
        }

        xhr.timeout = 6000
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(daemonStopRequested) return
                if(!xhr.responseText) return;

                try{
                    var resp = JSON.parse(xhr.responseText.toString())
                    if(resp.status === "OK"){
                        if(parseInt(resp.last_known_block_index,10) <= 0) return;
                        statusLine += (resp.synced ? "Synced " : "Synchronizing... ")
                        statusLine += +resp.height+"/"+resp.last_known_block_index
                        var donePercent = ((parseInt(resp.height, 10)/parseInt(resp.last_known_block_index))*100).toPrecision(4)
                        donePercent = donePercent > 99.99 ? 100 : donePercent
                        statusLine += " (" + donePercent.toString() + "%)";
                        statusText = statusLine
                    }
                }catch(e){
                    console.log(xhr.responseText.toString())
                }
            }
        }
        xhr.open("GET", "http://"+settings.rpcBindIp+":"+settings.rpcBindPort+"/getinfo")
        xhr.send()
    }

    function delay(delayTime, cb){
        delayTimer.interval = delayTime
        delayTimer.repeat = false
        delayTimer.triggered.connect(cb)
        delayTimer.start()
    }

    Timer {
        id: delayTimer
    }

    Timer {
       id: syncInfoTimer
       interval: 3000; running: false; repeat: true
       onTriggered: getSyncInfo()
    }

    statusBar: StatusBar {
        id: mainStatus
        RowLayout {
            anchors.fill: parent
            Label {
                id: statusBarText
                text: statusText
                Layout.alignment: Qt.AlignRight
                leftPadding: 8
                rightPadding: 8
            }
        }
    }

    MessageDialog {
        id: quitConfirmDialog
        title: "Confirmation"
        icon: StandardIcon.Question
        text: "Daemon is currently running, are you sure want to stop the daemon and quit?"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            syncInfoTimer.stop()
            daemonStopRequested = true
            appQuitRequested = true
            statusText = "Stopping daemon, may took a while to complete, please be patient..."
            daemonLauncher.stop()
            //Qt.quit()
        }
        onNo: {
            appQuitRequested = false
            daemonStopRequested = false
            delayTimer.stop()
            syncInfoTimer.restart()
        }
    }

    MessageDialog {
        id: messageDialog
        visible: false
        modality: Qt.WindowModal
        title: "Error"
        text: ""
        informativeText: ""
        detailedText: ""
    }

    Settings {
        id: settings
        property string daemonPath: "TurtleCoind"
        property string feeAddress: ""
        property int feeAmount: 0
        property string p2pBindIp: "0.0.0.0"
        property int p2pBindPort: 11897
        property int p2pExternalPort: 0
        property string rpcBindIp: "127.0.0.1"
        property int rpcBindPort: 11898
        property string dataDir: ""

    }

    Launcher {
        id: daemonLauncher
        cmdName: settings.daemonPath
        arguments: ["--dump-config"]
        onProcessStarted: {
            statusText = "Started, waiting for sync status..."
            dstate = "started"
            syncInfoTimer.restart()
        }
        onProcessStopped: {
            statusText  = "Stopped"
            dstate = "finished"
            syncInfoTimer.stop()
            daemonStopRequested = false
            if(appQuitRequested){
                delay(1000, function(){
                    Qt.quit();
                })
            }

        }
        onProcessError: {
            messageDialog.text = errors
            messageDialog.visible = true
            statusText  = "Stopped"
            dstate = "stopped"
            syncInfoTimer.stop()
            if(appQuitRequested){
                delay(1000, function(){
                    Qt.quit();
                })
            }
        }
        onStatusChanged: {
            statusText = status
            launcherButton.focus = false
        }
        onOutputChanged: {
            tabView.currentIndex = 2
            logViewPage.active = true
            logViewPage.forceActiveFocus()
            logViewPage.activeFocusOnTab = true
            turtleBuchet.logOutput = outputs
        }
    }

    TabView {
        id: tabView
        anchors.fill: parent
        anchors.margins: 8

        Tab {
            id: launcherPage
            title: "Quick Start"
            QuickStart {
                id: quickLauncher
                processState: dstate
            }
        }

        Tab {
            id: configPage
            title: "Daemon Options"
            DaemonOptions {
            }
        }

        Tab {
            id: logViewPage
            title: "Log Viewer"
            LogViewer {
            }
        }
    }
}
