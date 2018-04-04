SenecaWeb = require('seneca-web')
Express = require('express')
Router = Express.Router
context = new Router()

senecaWebConfig = {
  context: context,
  adapter: require('seneca-web-adapter-express'),
  options: {parseBody: false}
}

app = Express()
  .use(require('body-parser').json())
  .use(context)
  .listen(3001)

seneca = require('seneca')()
  .use('entity')
  .use(SenecaWeb, senecaWebConfig)
  .use('front_end_api')
  .client({type: 'tcp', port: 3000, pin: 'area:product'})
  .client({type: 'tcp', port: 3004, pin: 'area:orders'})

