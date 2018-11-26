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

import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Window 2.0

Item {
    id: daemonLogViewer
    width: 580
    height: 400
    SystemPalette { id: palette }
    clip: true


    Flickable {
          id: flickable
          flickableDirection: Flickable.VerticalFlick
          anchors.fill: parent

          TextArea.flickable: TextArea {
              id: textArea
              textFormat: Qt.PlainText
              focus: true
              selectByMouse: true
              persistentSelection: true
              leftPadding: 8
              rightPadding: 8
              topPadding: 8
              bottomPadding: 8
              background: null
              font.family: "monospace"
              font.pointSize: 8
              readOnly: true
              wrapMode: TextArea.NoWrap
              MouseArea {
                  acceptedButtons: Qt.RightButton
                  anchors.fill: parent
                  onClicked: contextMenu.open()
              }
              text: turtleBuchet.logOutput
              onTextChanged: {
                  cursorPosition = text.length
              }
          }

          ScrollBar.vertical: ScrollBar {}
      }

}
