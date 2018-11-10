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

#pragma once

#ifdef QT_WIDGETS_LIB
#include <QtWidgets/QApplication>
#else
#include <QtGui/QGuiApplication>
#endif

QT_BEGIN_NAMESPACE

#ifdef QT_WIDGETS_LIB
#define QtQuickControlsApplication QApplication
#else
#define QtQuickControlsApplication QGuiApplication
#endif

QT_END_NAMESPACE
