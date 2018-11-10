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

#include "launcher.h"
#include <QUrl>
#include <QDateTime>
#include <QTimer>

Launcher::Launcher(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
}

QString Launcher::pid() const
{
    return m_pid;
}

QString Launcher::outputs() const
{
    return m_outputs;
}

QString Launcher::errors() const
{
    return m_error;
}

QString Launcher::status() const
{
    return m_status;
}

QString Launcher::cmdName() const
{
    return m_cmdName;
}

void Launcher::setCmdName(const QString &cmdName)
{
    m_cmdName = cmdName;
}

QVariantList Launcher::arguments() const
{
    return m_arguments;
}

void Launcher::setArguments(const QVariantList &arguments)
{
    m_arguments = arguments;
}

void Launcher::launch()
{
    QStringList args{};
    for (auto &m_argument : m_arguments)
    {
        QString strArgs = m_argument.toString();
        if (strArgs.startsWith("file:") )
        {
            args << QUrl(strArgs).path();
        }
        else
        {
            args << strArgs;
        }
    }

    QString cmdPath = QUrl(m_cmdName).path();

    while(m_process->state() != QProcess::NotRunning)
    {
        m_process->terminate();
    }

    m_process->closeWriteChannel();

    // setup read channels
    m_process->setReadChannelMode(QProcess::MergedChannels);
    m_process->setReadChannel(QProcess::StandardOutput);

    // start the process
    m_process->start(cmdPath, args);
    m_process->setCurrentWriteChannel(QProcess::MergedChannels);

    connect(m_process, &QProcess::started, [this]()
    {
        m_status = "Ready, process id: " + QString::number(m_process->processId());
        emit processStarted();
    });

    // error signal
    connect(m_process, &QProcess::errorOccurred, [this]()
    {
        switch(m_process->error())
        {
            case QProcess::FailedToStart:
                m_error = "Failed to start the daemon: " + QString(m_process->errorString());
                break;
            case QProcess::Crashed:
                m_error = "";
                break;
            default:
                m_error = "Unable to start the daemon.";
                break;
        }

        m_process->closeWriteChannel();
        if(m_error.length()){
            emit processError();
        }

    });

    // finished signal
    connect(m_process, static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished),
            [=]  (int exitCode, QProcess::ExitStatus exitStatus)
    {
        if(exitStatus == QProcess::NormalExit)
        {
            m_status = "Stopped at " + QDateTime::currentDateTimeUtc().toString();
        }
        else
        {
            m_status = "Error occured, error code: " + QString::number(exitCode) + " " + m_process->errorString();
        }
        emit processStopped();
    });

    connect(m_process, &QProcess::readyRead, [this]()
    {
        QString out = QString(m_process->readAll()).trimmed();
        if(out.length())
        {
            m_outputs = QDateTime::currentDateTimeUtc().toString() + "\n";
            m_outputs += out;
        }
        emit outputChanged();
    });
}

void Launcher::stop()
{
    if(m_process->state() == QProcess::Running)
    {
        m_process->terminate();
    }
}

void Launcher::kill()
{
    if(m_process->state() == QProcess::Running)
    {
        m_process->kill();
    }
}

bool Launcher::isRunning()
{
    return (m_process->state() == QProcess::Running);
}
