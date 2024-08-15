#ifndef ROISENDER_H
#define ROISENDER_H

#include <QTcpSocket>
#include <QObject>

class roiSender : public QObject
{
    Q_OBJECT
public:
    explicit roiSender(QObject *parent = nullptr);

    // Method to send data
    Q_INVOKABLE void sendData(const QString &data);

private:
    QTcpSocket *tcpSocket;
};

#endif // ROISENDER_H

