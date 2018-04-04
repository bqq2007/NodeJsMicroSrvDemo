email = require('emailjs')
server = email.server.connect(
  {
    user: "qqbao@fiberhome.com",
    password: "transformers747",
    host: "smtp.fiberhome.com",
    ssl: false
  }
)

email_imp = (options) ->
  @add {init: 'plugin'}, (msg, respond) ->
    console.log "email_plugin plugin loaded..."
    respond()

  # 接口字段{content, to, subject}
  @add {area: "email", action: "send"}, (args, done) ->
    console.log "email send..."
    server.send(
      {
        text: args.content,
        from: "qqbao@fiberhome.com",
        to: args.to,
        subject: args.subject
      }, (err, message) ->
        console.log (err || message)
        done(err, message)
    )

module.exports = email_imp
