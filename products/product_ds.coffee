# 插件：/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

product_ds = (options) ->
  # 初始化
  @add {init: 'product_ds'}, (msg, respond) ->
    console.log "product_ds plugin loaded..."
    respond()

  # 获取商品列表
  @add {area: "product", action: "fetch"}, (args, done) ->
    console.log 'fetch api call'
    products = @make("products")
    products.list$ {}, (err, result) ->
      done(err, result)

  #  根据分类获取商品列表
  @add {area: "product", action: "fetch", criteria: "byCategory"}, (args, done) ->
    console.log 'fetch byCategory api call'
    products = @make("products")
    products.list$ {category: args.category}, done

  # 根据ID获取商品
  @add {area: "product", action: "fetch", criteria: "byId"}, (args, done) ->
    console.log 'fetch byId api call'
    product = @make("products")
    product.load$(args.id, done)

  # 根据ID获取商品内：部使用
  @add {area: "product", action: "fetch", criteria: "byIdInner"}, (args, done) ->
    console.log 'fetch byId api call'
    product = @make("products")
    product.load$(args.id, done)

  # 添加商品
  @add {area: "product", action: "add"}, (args, done) ->
    console.log 'add api call'
    console.log args.category
    #console.log {category, name, description, price} = JSON.parse args.args.body
    products = @make("products")
    products.category = args.category
    products.name = args.name
    products.description = args.description
    products.price = args.price

    products.save$(
      (err, product) ->
        done err, product.data$(false)  # 原文这里是products.data
    )

  # 根据id删除商品
  @add {area: "product", action: "remove"}, (args, done) ->
    console.log 'remove api call'
    product = @make("products");
    product.remove$(
      args.id, (err) ->
      done(err, null)
    )

  # 根据id获取商品信息并编辑
  @add {area: "product", action: "edit"}, (args, done) ->
    console.log 'edit api call'
    # 先根据id查询已有商品信息
    @act {area: "product", action: "fetch", criteria: "byIdInner", id: args.id}, (err, result) ->
      # result为查出的结果，根据输入数据修改该结果
      result.data$(
        {
          name: args.name,
          category: args.category
          description: args.description
          price: args.price
        }
      )
      # 将修改后的结果存库
      result.save$ (err, product) ->
        done(err, product.data$(false))

module.exports = product_ds
