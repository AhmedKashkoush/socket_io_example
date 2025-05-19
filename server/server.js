const app = require('express')()
const http = require('http').createServer(app)
const io = require('socket.io')(http)
const cors = require('cors')

app.use(cors())

http.listen(3000, () => {
  console.log('Listening on port 3000')
})

io.on('connection', async socket => {
  const { id, name } = socket.handshake.query
  socket.user = { id, name }
  console.log(`A user ${name} connected with id ${id}`)
  const sockets = await io.fetchSockets()

  io.emit(
    'get-connected-users',
    sockets.map(s => s.user)
  )

  socket.on('join-room', room => {
    const { id, name } = socket.user
    socket.join(room)
    console.log(`A user ${name} with id ${id} joined room ${room}`)
  })
  socket.on('leave-room', room => {
    const { id, name } = socket.user
    socket.leave(room)
    console.log(`A user ${name} with id ${id} left room ${room}`)
  })

  socket.on('send-message', async (message) => {
    const { to } = message
    const sockets = await io.fetchSockets()
    const socket = sockets.find(s => s.user.id == to)
    io.to(socket.id).emit('receive-message',message)
  })

  socket.on('get-connected-users', async () => {
    const sockets = await io.fetchSockets()
    io.emit(
      'get-connected-users',
      sockets.map(s => s.user)
    )
  })

  socket.on('disconnect', async () => {
    const sockets = await io.fetchSockets()

    io.emit(
      'get-connected-users',
      sockets.map(s => s.user)
    )
    console.log(`A user disconnected ${socket.id}`)
  })
})
