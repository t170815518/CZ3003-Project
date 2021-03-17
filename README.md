# CZ3003-Project
## Communication Protocal 
### WebSocket
 WebSocket gives you a bidirectional, full-duplex communications channel that operates over HTTP through a single socket.
To begin, you will listen for an *event* called connection. Upon receiving a connection event, the provided WebSocket object will be used to send back the “Hello, World!” greeting.
#### Basic flow
1. User A creates a room and receives Room ID from Server.
2. User B enters room ID to join the quiz.
3. User A and B submit the answer to Server. 
4. If User does not submit the answer in time, he/she will be judged as "lose".
5. Server judges who has given the correct answer and sends the win/lose status back to Users. 
6. Users' HP value updates accordingly, for example, HP value of User who gave the wrong/late/no answer will decrease by 1. 