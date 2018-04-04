promise = require('bluebird')

front_end_api = (options) ->
  seneca = this
  act = promise.promisify(seneca.act, {context: seneca})

  # 获取全部商品列表
  seneca.add {area: "ui", action: "products"}, (args, done) ->
    this.log.warn this.fixedargs['tx$'] + "Load products list..."
    act({area: "product", action: "fetch"})
      .then((result) ->
        done(null, result))
      .catch((err) -> done(err, null))

  # 获取全部工单列表
  seneca.add {area: "ui", action: "orders"}, (args, done) ->
    console.log "Load orders list..."
    act({area: "orders", action: "fetch"})
      .then((result) -> done(null, result))
      .catch((err) -> done(err, null))

  # 根据id获取商品信息
  seneca.add {area: "ui", action: "productbyid"}, (args, done) ->
    console.log "Get product by id..."
    id = args.args.params.id
    act({area: "product", action: "fetch", criteria: "byId", id: id})
      .then((result) -> done(null, result))
      .catch((err) -> done(err, null))

  # 创建一个单一商品的购买订单
  # 表单字段: {productid, email, name}
  seneca.add {area: "ui", action: "createorder"}, (args, done) ->
    console.log "Create order..."
    act({area: "product", action: "fetch", criteria: "byId", id: args.args.body.productid})
      .then((product) ->
        act({area: "orders", action: "create", products: [product], email: args.args.body.email, name: args.args.body.name})
          .then((order) -> done(null, order))
          .catch((err) -> done(err, null))
      )
      .catch((err) -> done(err, null))

  # 插件初始化
  @add "init:front_end_api", (msg, respond) ->
    @act(
      'role:web',
      {
        routes: {
          prefix: '/api',
          pin: 'area:ui,action:*',
          map: {
            products: {GET:true},
            # http://localhost:3001/api/productbyid/id
            productbyid: {GET:true, suffix: '/:id'},
            orders: {GET:true},
            createorder: {POST:true}
          }
        }
      }
    )
    respond()

module.exports = front_end_api

