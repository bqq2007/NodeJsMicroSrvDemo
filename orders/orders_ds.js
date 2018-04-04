// Generated by CoffeeScript 1.12.7
(function() {
  var orders_ds;

  orders_ds = function(options) {
    this.add({
      init: 'orders_ds'
    }, function(msg, respond) {
      console.log("orders_ds plugin loaded...");
      return respond();
    });
    this.add({
      area: "orders",
      action: "fetch"
    }, function(args, done) {
      var orders;
      console.log("Orders fetch...");
      orders = this.make("orders");
      return orders.list$({
        id: args.id
      }, done);
    });
    this.add({
      area: "orders",
      action: "delete"
    }, function(args, done) {
      var orders;
      console.log("Orders delete...");
      orders = this.make("orders");
      return orders.remove$({
        id: args.id
      }, function(err) {
        return done(err, null);
      });
    });
    return this.add({
      area: "orders",
      action: "create"
    }, function(args, done) {
      var i, idx, len, orders, product, productids, products, total;
      console.log("Orders create...");
      products = args.products;
      total = 0.0;
      productids = new Array();
      idx = 0;
      for (i = 0, len = products.length; i < len; i++) {
        product = products[i];
        total += product.price;
        productids[idx] = product.id;
        idx++;
      }
      orders = this.make("orders");
      orders.total = total;
      orders.customer_email = args.email;
      orders.customer_name = args.name;
      orders.productids = productids;
      return orders.save$(function(err, order) {
        var mailPattern;
        mailPattern = {
          area: "email",
          action: "send",
          content: "存库后发送邮件",
          to: "qqbao@fiberhome.com.cn",
          subject: "您的新订单"
        };
        this.act(mailPattern, function(err, mailRes) {
          return console.log(err || mailRes);
        });
        return done(err, order.data$(false));
      });
    });
  };

  module.exports = orders_ds;

}).call(this);

//# sourceMappingURL=orders_ds.js.map
