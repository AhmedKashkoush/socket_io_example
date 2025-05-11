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
  socket.on('disconnect', async () => {
    const sockets = await io.fetchSockets()

    io.emit(
      'get-connected-users',
      sockets.map(s => s.user)
    )
    console.log(`A user disconnected ${socket.id}`)
  })
})
