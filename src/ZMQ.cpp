// #include <QCoreApplication>
// #include <zmq.h>
// #include <iostream>

// int main(int argc, char *argv[])
// {
//     QCoreApplication a(argc, argv);

//     // ZeroMQ context
//     void* context = zmq_ctx_new();
//     if (!context) {
//         std::cerr << "Error creating ZeroMQ context\n";
//         return 1;
//     }

//     // ZeroMQ socket
//     void* socket = zmq_socket(context, ZMQ_REQ);
//     if (!socket) {
//         std::cerr << "Error creating ZeroMQ socket\n";
//         zmq_ctx_destroy(context);
//         return 1;
//     }

//     // Connect to a ZeroMQ endpoint
//     zmq_connect(socket, "tcp://localhost:5555");

//     // Your ZeroMQ code goes here...

//     // Clean up
//     zmq_close(socket);
//     zmq_ctx_destroy(context);

//     return a.exec();
// }
