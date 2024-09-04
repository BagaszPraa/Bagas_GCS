#include "roisender.h"

roiSender::roiSender(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    // tcpSocket->connectToHost("127.0.0.1", 6000);  // Ganti dengan IP dan port server tujuan
}
void roiSender::connectToHost(const QString &host, quint16 port)
{
    tcpSocket->connectToHost(host, port);
}
void roiSender::sendData(const QString &data)
{
    if(tcpSocket->state() == QAbstractSocket::ConnectedState)
    {
        tcpSocket->write(data.toUtf8());
        tcpSocket->flush();
    }
}
void roiSender::disconnectFromHost()
{
    if(tcpSocket->state() == QAbstractSocket::ConnectedState)
    {
        tcpSocket->disconnectFromHost();
    }
}
