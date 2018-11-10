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
    id: configTab
    width: 580
    height: 400
    SystemPalette {
        id: palette
    }
    clip: true

    ScrollView {
        id: configScrollView
        height: implicitHeight
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            leftMargin: 12
            rightMargin: 12
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 8
            Layout.fillWidth: true
            Item {
                Layout.preferredHeight: 4
            }

            RowLayout {
                Layout.fillWidth: true
                width: parent.width
                spacing: 8

                Label {
                    text: "P2P IP:"
                    Layout.alignment: Qt.AlignBaseline
                    Layout.minimumWidth: (configTab.width / 5)
                    Layout.preferredWidth: (configTab.width / 4.25)
                }

                TextField {
                    id: bindIp
                    text: settings.p2pBindIp
                    Layout.fillWidth: true
                    inputMask: "000.000.000.000;"
                    onTextChanged: {
                        settings.p2pBindIp = text
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Label {
                    text: "P2P Port:"
                    Layout.alignment: Qt.AlignBaseline
                    Layout.minimumWidth: (configTab.width / 5)
                    Layout.preferredWidth: (configTab.width / 4.25)
                }

                TextField {
                    id: bindPort
                    text: settings.p2pBindPort
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 10240
                        top: 65535
                    }
                    onTextChanged: {
                        settings.p2pBindPort = text
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Label {
                    text: "P2P External Port:"
                    Layout.alignment: Qt.AlignBaseline
                    Layout.minimumWidth: (configTab.width / 5)
                    Layout.preferredWidth: (configTab.width / 4.25)
                }

                TextField {
                    id: bindPortExternal
                    text: settings.p2pExternalPort
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 0
                        top: 65535
                    }
                    onTextChanged: {
                        settings.p2pExternalPort = text
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                width: parent.width
                spacing: 8

                Label {
                    text: "RPC IP:"
                    Layout.alignment: Qt.AlignBaseline
                    Layout.minimumWidth: (configTab.width / 5)
                    Layout.preferredWidth: (configTab.width / 4.25)
                }

                TextField {
                    id: rpcIp
                    text: settings.rpcBindIp
                    Layout.fillWidth: true
                    inputMask: "000.000.000.000;"
                    onTextChanged: {
                        settings.rpcBindIp = text
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Label {
                    text: "RPC Port:"
                    Layout.alignment: Qt.AlignBaseline
                    Layout.minimumWidth: (configTab.width / 5)
                    Layout.preferredWidth: (configTab.width / 4.25)
                }

                TextField {
                    id: rpcPort
                    text: settings.rpcBindPort
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 10240
                        top: 65535
                    }
                    onTextChanged: {
                        settings.rpcBindPort = text
                    }
                }
            }
        }
    }
}
