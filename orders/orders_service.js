// Generated by CoffeeScript 1.12.7
(function() {
  require('seneca')().use('entity').use('mongo-store', {
    uri: 'mongodb://10.99.20.234:27017/seneca'
  }).use('orders_ds').listen({
    type: 'tcp',
    port: 3004,
    pin: 'area:orders'
  }).client({
    type: 'tcp',
    port: 3002,
    pin: 'area:email'
  });

}).call(this);

//# sourceMappingURL=orders_service.js.map
