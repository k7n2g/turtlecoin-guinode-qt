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
#include "qqa.h"
#include "launcher.h"
#include <QtQml/QQmlApplicationEngine>
#include <QtGui/QSurfaceFormat>
#include <QtQuick/QQuickWindow>

int main(int argc, char *argv[])
{
    QtQuickControlsApplication app(argc, argv);
    app.setOrganizationName("TurtleCoin");
    app.setOrganizationDomain("turtlecoin.lol");
    app.setApplicationName("TRTLBuchets");

    qmlRegisterType<Launcher>("Launcher", 1, 0, "Launcher");

    if (QCoreApplication::arguments().contains(QLatin1String("--coreprofile")))
    {
        QSurfaceFormat fmt;
        fmt.setVersion(4, 4);
        fmt.setProfile(QSurfaceFormat::CoreProfile);
        QSurfaceFormat::setDefaultFormat(fmt);
    }

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QQmlApplicationEngine engine(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
    {
        return -1;
    }
    return app.exec();
}
