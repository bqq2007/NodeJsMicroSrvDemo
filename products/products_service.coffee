# 服务器：/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
require('seneca')()
  .use('entity') # 此句在客户端和服务端都必须使用
  .use('mongo-store', {uri: 'mongodb://10.99.20.234:27017/seneca'})
  .use('product_ds')
  # listen for area:product messages
  # IMPORTANT: must match client
  .listen({type: 'tcp', port: 3000, pin: 'area:product'})
