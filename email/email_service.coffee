
# 服务器：/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
require('seneca')()
  .use('email_imp')
  # listen for area:product messages
  # IMPORTANT: must match client
  .listen({type: 'tcp', port: 3002, pin: 'area:email'})
