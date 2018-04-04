
orders_ds = (options) ->
  @add {init: 'orders_ds'}, (msg, respond) ->
    console.log "orders_ds plugin loaded..."
    respond()

  @add {area: "orders", action: "fetch"}, (args, done) ->
    console.log "Orders fetch..."
    orders = @make("orders")
    orders.list$ id: args.id, done

  @add {area: "orders", action: "delete"}, (args, done) ->
    console.log "Orders delete..."
    orders = @make("orders")
    orders.remove$ {id: args.id}, (err) ->
      done(err, null)

  # order字段：{total, customer_email, customer_name}
  @add {area: "orders", action: "create"}, (args, done) ->
    console.log "Orders create..."
    products = args.products
    total = 0.0
    productids = new Array()
    idx = 0
    for product in products
      total += product.price
      productids[idx] = product.id
      idx++

    orders = @make("orders")
    orders.total = total
    orders.customer_email = args.email
    orders.customer_name = args.name
    orders.productids = productids
    orders.save$(
      (err, order) ->
        # 存库后发送邮件
        mailPattern = {
          area: "email",
          action: "send",
          content: "存库后发送邮件",
          to: "qqbao@fiberhome.com.cn",
          subject: "您的新订单"
        }
        @act(mailPattern, (err, mailRes) ->
          console.log err || mailRes
        )
        done err, order.data$(false)
    )

module.exports = orders_ds
