#ifndef ROISENDER_H
#define ROISENDER_H

#include <QTcpSocket>
#include <QObject>

class roiSender : public QObject
{
    Q_OBJECT
public:
    // Constructor, initializing the object with an optional parent
    explicit roiSender(QObject *parent = nullptr);

    // Method to connect to the host, callable from QML
    Q_INVOKABLE void connectToHost(const QString &host, quint16 port);

    // Method to send data, callable from QML
    Q_INVOKABLE void sendData(const QString &data);
    Q_INVOKABLE void disconnectFromHost();

private:
    // Private member to handle TCP socket communication
    QTcpSocket *tcpSocket;
};

#endif // ROISENDER_H
