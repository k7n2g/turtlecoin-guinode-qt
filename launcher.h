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

#include <QObject>
#include <QProcess>
#include <QVariantList>

class Launcher : public QObject
{
    Q_OBJECT

public:
    explicit Launcher(QObject *parent = nullptr);
    Q_PROPERTY( QString         cmdName      READ cmdName    WRITE setCmdName  )
    Q_PROPERTY( QVariantList    arguments    READ arguments  WRITE setArguments )
    Q_PROPERTY( QString         pid          READ pid )
    Q_PROPERTY( QString         status       READ status)
    Q_PROPERTY( QString         outputs      READ outputs)
    Q_PROPERTY( QString         errors       READ errors )

    QString pid() const;
    QString status() const;
    QString outputs() const;
    QString errors() const;

    QString cmdName() const;
    void setCmdName(const QString &cmdName);

    QVariantList arguments() const;
    void setArguments(const QVariantList &arguments);

    Q_INVOKABLE void launch();
    Q_INVOKABLE void stop();

signals:
    void statusChanged();
    void outputChanged();
    void processStarted();
    void processStopped();
    void processError();

private:
    QProcess *m_process;
    QString m_cmdName;
    QVariantList m_arguments;
    QString m_pid;
    QString m_status;
    QString m_outputs;
    QString m_error;
};
