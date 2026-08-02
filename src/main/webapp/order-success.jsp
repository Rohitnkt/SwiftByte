<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swiftbyte.model.*, java.util.*, java.text.*, java.math.BigDecimal" %>
<%
    Order order = (Order) request.getAttribute("order");
    User user   = (User)  session.getAttribute("user");

    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/restaurants");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String placedAt = (order.getCreatedAt() != null) ? sdf.format(order.getCreatedAt()) : "-";

    // ETA = placed time + 35 min
    Calendar eta = Calendar.getInstance();
    if (order.getCreatedAt() != null) eta.setTime(order.getCreatedAt());
    eta.add(Calendar.MINUTE, 35);
    String etaText = new SimpleDateFormat("hh:mm a").format(eta.getTime());

    BigDecimal subtotal = order.getSubtotal()    != null ? order.getSubtotal()    : BigDecimal.ZERO;
    BigDecimal delFee   = order.getDeliveryFee() != null ? order.getDeliveryFee() : BigDecimal.ZERO;
    BigDecimal tax      = order.getTax()         != null ? order.getTax()         : BigDecimal.ZERO;
    BigDecimal total    = order.getTotal()       != null ? order.getTotal()       : BigDecimal.ZERO;

    String status = order.getStatus() != null ? order.getStatus() : "Placed";
    boolean cancellable = "Placed".equalsIgnoreCase(status);
    boolean cancelled   = "Cancelled".equalsIgnoreCase(status);

    String addr = (order.getDeliveryAddress() != null && !order.getDeliveryAddress().trim().isEmpty())
                    ? order.getDeliveryAddress()
                    : (user != null && user.getDeliveryAddress() != null ? user.getDeliveryAddress() : "-");

    String rName = (order.getRestaurantName() != null && !order.getRestaurantName().trim().isEmpty())
                    ? order.getRestaurantName() : "SwiftByte Kitchen";

    String flash = (String) session.getAttribute("flash");
    if (flash != null) session.removeAttribute("flash");

    List<OrderItem> items = order.getItems() != null ? order.getItems() : new ArrayList<OrderItem>();

    // tracker step index
    int step = 1;
    if ("Preparing".equalsIgnoreCase(status))        step = 2;
    else if ("Out for Delivery".equalsIgnoreCase(status)) step = 3;
    else if ("Delivered".equalsIgnoreCase(status))   step = 4;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Order #<%= order.getOrderId() %> Confirmed · SwiftByte</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
  *{margin:0;padding:0;box-sizing:border-box}
  :root{
    --orange:#ff5722; --orange-dark:#ef4e1c; --orange-soft:#fff5f0;
    --ink:#1c1c1c; --ink-2:#4a4a4a; --ink-3:#8a8a8a;
    --line:#f0ece6; --bg:#fdfcfa; --green:#0f8a4f; --green-soft:#eaf7f0;
  }
  body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--ink);-webkit-font-smoothing:antialiased}

  /* ---------- navbar ---------- */
  .navbar{position:sticky;top:0;z-index:50;background:#fff;border-bottom:1px solid var(--line);box-shadow:0 1px 12px rgba(0,0,0,.04)}
  .nav-inner{max-width:1120px;margin:0 auto;padding:0 24px;height:68px;display:flex;align-items:center;justify-content:space-between;gap:24px}
  .brand{display:flex;align-items:center;gap:9px;font-size:22px;font-weight:800;letter-spacing:-.5px;color:var(--ink);text-decoration:none}
  .brand i{color:var(--orange);font-size:20px}
  .nav-links{display:flex;align-items:center;gap:4px}
  .nav-links a{display:inline-flex;align-items:center;gap:8px;padding:9px 14px;border-radius:10px;font-size:14.5px;font-weight:600;color:var(--ink-2);text-decoration:none;transition:.18s}
  .nav-links a i{font-size:14px;color:#9a9a9a;transition:.18s}
  .nav-links a:hover{background:var(--orange-soft);color:var(--orange)}
  .nav-links a:hover i{color:var(--orange)}
  .nav-cta{padding:10px 20px!important;background:var(--orange);color:#fff!important;border-radius:10px;font-weight:700;box-shadow:0 4px 14px rgba(255,87,34,.28)}
  .nav-cta i{color:#fff!important}
  .nav-cta:hover{background:var(--orange-dark)!important;color:#fff!important}

  /* ---------- layout ---------- */
  .wrap{max-width:1120px;margin:0 auto;padding:32px 24px 72px}
  .grid{display:grid;grid-template-columns:1fr 380px;gap:24px;align-items:start}
  .card{background:#fff;border:1px solid var(--line);border-radius:16px;padding:24px}
  .card + .card{margin-top:20px}
  .card-title{font-size:15px;font-weight:800;letter-spacing:-.2px;display:flex;align-items:center;gap:9px;margin-bottom:18px}
  .card-title i{color:var(--orange);font-size:14px}

  /* ---------- flash ---------- */
  .flash{max-width:1120px;margin:20px auto -8px;padding:0 24px}
  .flash-in{background:var(--green-soft);border:1px solid #bfe6d0;color:var(--green);padding:13px 18px;border-radius:12px;font-size:14px;font-weight:600;display:flex;align-items:center;gap:10px}

  /* ---------- hero ---------- */
  .hero{background:#fff;border:1px solid var(--line);border-radius:18px;padding:36px 32px;text-align:center;position:relative;overflow:hidden}
  .hero:before{content:'';position:absolute;inset:0 0 auto;height:4px;background:linear-gradient(90deg,var(--orange),#ffa270)}
  .tick{width:66px;height:66px;margin:0 auto 18px;border-radius:50%;background:var(--green-soft);color:var(--green);display:grid;place-items:center;font-size:28px;animation:pop .5s cubic-bezier(.2,1.4,.4,1)}
  @keyframes pop{0%{transform:scale(.5);opacity:0}100%{transform:scale(1);opacity:1}}
  .hero h1{font-size:27px;font-weight:800;letter-spacing:-.8px;margin-bottom:8px}
  .hero p{font-size:14.5px;color:var(--ink-3);max-width:440px;margin:0 auto}
  .meta{display:flex;justify-content:center;flex-wrap:wrap;gap:10px;margin-top:22px}
  .chip{background:#faf8f5;border:1px solid var(--line);padding:8px 15px;border-radius:999px;font-size:13px;font-weight:600;color:var(--ink-2);display:inline-flex;align-items:center;gap:7px}
  .chip i{color:var(--orange);font-size:12px}
  .chip.eta{background:var(--orange-soft);border-color:#ffd9c9;color:var(--orange-dark)}
  .chip.cancelled{background:#fdeaea;border-color:#f5c6c6;color:#c0392b}
  .chip.cancelled i{color:#c0392b}

  /* ---------- tracker ---------- */
  .track{display:flex;align-items:flex-start;margin-top:4px}
  .tstep{flex:1;text-align:center;position:relative}
  .tstep:before,.tstep:after{content:'';position:absolute;top:17px;height:3px;background:var(--line);width:50%}
  .tstep:before{left:0}.tstep:after{right:0}
  .tstep:first-child:before,.tstep:last-child:after{display:none}
  .tstep.done:before,.tstep.done:after{background:var(--orange)}
  .tstep.active:before{background:var(--orange)}
  .tdot{width:36px;height:36px;margin:0 auto 10px;border-radius:50%;background:#fff;border:3px solid var(--line);color:#c4c4c4;display:grid;place-items:center;font-size:13px;position:relative;z-index:2}
  .tstep.done .tdot,.tstep.active .tdot{border-color:var(--orange);background:var(--orange);color:#fff}
  .tstep.active .tdot{box-shadow:0 0 0 5px rgba(255,87,34,.15)}
  .tlabel{font-size:12.5px;font-weight:700;color:var(--ink-3)}
  .tstep.done .tlabel,.tstep.active .tlabel{color:var(--ink)}

  /* ---------- items ---------- */
  .item{display:flex;align-items:center;gap:14px;padding:14px 0;border-bottom:1px dashed var(--line)}
  .item:last-child{border-bottom:0;padding-bottom:0}
  .item-icon{width:42px;height:42px;flex-shrink:0;border-radius:11px;background:var(--orange-soft);color:var(--orange);display:grid;place-items:center;font-size:15px}
  .item-info{flex:1;min-width:0}
  .item-name{font-size:14.5px;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .item-sub{font-size:12.5px;color:var(--ink-3);margin-top:3px}
  .item-amt{font-size:14.5px;font-weight:700;white-space:nowrap}

  /* ---------- bill ---------- */
  .bill{position:sticky;top:96px}
  .brow{display:flex;justify-content:space-between;align-items:center;font-size:14px;color:var(--ink-2);padding:9px 0}
  .brow span:last-child{font-weight:600;color:var(--ink)}
  .bdiv{height:1px;background:var(--line);margin:10px 0}
  .btotal{display:flex;justify-content:space-between;align-items:center;font-size:17px;font-weight:800;letter-spacing:-.3px}
  .btotal span:last-child{color:var(--orange)}
  .paid{margin-top:16px;background:#faf8f5;border-radius:11px;padding:12px 14px;font-size:13px;font-weight:600;color:var(--ink-2);display:flex;align-items:center;gap:9px}
  .paid i{color:var(--green)}

  /* ---------- address ---------- */
  .addr{display:flex;gap:13px}
  .addr-ic{width:38px;height:38px;flex-shrink:0;border-radius:10px;background:var(--orange-soft);color:var(--orange);display:grid;place-items:center;font-size:14px}
  .addr-name{font-size:14.5px;font-weight:700;margin-bottom:4px}
  .addr-txt{font-size:13.5px;color:var(--ink-3);line-height:1.65}

  /* ---------- actions ---------- */
  .lbl{display:block;font-size:12.5px;font-weight:700;color:var(--ink-3);margin-bottom:7px;text-transform:uppercase;letter-spacing:.4px}
  select{width:100%;padding:12px 14px;border:1px solid var(--line);border-radius:11px;font-family:inherit;font-size:14px;font-weight:600;color:var(--ink-2);background:#fff;outline:none;cursor:pointer}
  select:focus{border-color:var(--orange)}
  .btn{width:100%;margin-top:12px;padding:13px;border:0;border-radius:11px;font-family:inherit;font-size:14.5px;font-weight:700;cursor:pointer;display:inline-flex;align-items:center;justify-content:center;gap:9px;transition:.18s}
  .btn-danger{background:#fff;border:1.5px solid #f0c9c9;color:#c0392b}
  .btn-danger:hover{background:#fdeaea;border-color:#e8b0b0}
  .btn-ghost{background:#fff;border:1.5px solid var(--line);color:var(--ink-2)}
  .btn-ghost:hover{background:#faf8f5}
  .note{font-size:12.5px;color:var(--ink-3);margin-top:11px;line-height:1.6}

  /* ---------- chat ---------- */
  .chat{position:fixed;right:22px;bottom:22px;width:330px;background:#fff;border:1px solid var(--line);border-radius:16px;box-shadow:0 18px 50px rgba(0,0,0,.14);display:none;overflow:hidden;z-index:99}
  .chat.open{display:block}
  .chat-h{background:var(--orange);color:#fff;padding:14px 16px;display:flex;justify-content:space-between;align-items:center;font-size:14.5px;font-weight:700}
  .chat-h button{background:rgba(255,255,255,.2);border:0;color:#fff;width:26px;height:26px;border-radius:8px;cursor:pointer;font-size:13px}
  .chat-b{height:250px;overflow-y:auto;padding:14px;background:var(--bg)}
  .msg{max-width:82%;padding:9px 13px;border-radius:13px;font-size:13.5px;line-height:1.55;margin-bottom:9px}
  .msg.bot{background:#fff;border:1px solid var(--line);color:var(--ink-2)}
  .msg.me{background:var(--orange);color:#fff;margin-left:auto}
  .chat-f{display:flex;gap:8px;padding:11px;border-top:1px solid var(--line)}
  .chat-f input{flex:1;padding:10px 13px;border:1px solid var(--line);border-radius:10px;font-family:inherit;font-size:13.5px;outline:none}
  .chat-f input:focus{border-color:var(--orange)}
  .chat-f button{background:var(--orange);border:0;color:#fff;width:40px;border-radius:10px;cursor:pointer}
  #cfx{position:fixed;inset:0;pointer-events:none;z-index:98}

  @media (max-width:900px){
    .grid{grid-template-columns:1fr}
    .bill{position:static}
  }
  @media (max-width:720px){
    .nav-inner{height:auto;padding:12px 16px;flex-wrap:wrap;gap:10px}
    .nav-links{width:100%;justify-content:space-between;gap:2px}
    .nav-links a{padding:8px 10px;font-size:13px}
    .nav-links a span{display:none}
    .nav-cta span{display:inline!important}
    .wrap{padding:20px 16px 56px}
    .hero{padding:28px 20px}
    .hero h1{font-size:22px}
    .card{padding:19px}
    .tlabel{font-size:10.5px}
    .chat{right:12px;left:12px;width:auto}
  }
</style>
</head>
<body>

<canvas id="cfx"></canvas>

<!-- NAVBAR -->
<div class="navbar">
  <div class="nav-inner">
    <a href="<%= request.getContextPath() %>/restaurants" class="brand"><i class="fas fa-bolt"></i> SwiftByte</a>
    <nav class="nav-links">
      <a href="<%= request.getContextPath() %>/restaurants"><i class="fas fa-utensils"></i><span>Order Food</span></a>
      <a href="<%= request.getContextPath() %>/profile"><i class="fas fa-user"></i><span>Profile</span></a>
      <a href="javascript:void(0)" onclick="toggleChat()"><i class="fas fa-headset"></i><span>Help</span></a>
      <a href="<%= request.getContextPath() %>/profile" class="nav-cta"><i class="fas fa-receipt"></i><span>My Orders</span></a>
    </nav>
  </div>
</div>

<% if (flash != null) { %>
<div class="flash"><div class="flash-in"><i class="fas fa-circle-check"></i> <%= flash %></div></div>
<% } %>

<div class="wrap">

  <!-- HERO -->
  <div class="hero">
    <div class="tick"><i class="fas <%= cancelled ? "fa-xmark" : "fa-check" %>"></i></div>
    <h1><%= cancelled ? "Order Cancelled" : "Order Placed Successfully!" %></h1>
    <p><%= cancelled
            ? "Your order has been cancelled. Any amount paid will be refunded within 3-5 working days."
            : "Thank you" + (user != null && user.getFullName() != null ? ", " + user.getFullName() : "") + "! " + rName + " has received your order and started preparing it." %></p>
    <div class="meta">
      <span class="chip"><i class="fas fa-hashtag"></i> Order #<%= order.getOrderId() %></span>
      <span class="chip"><i class="fas fa-clock"></i> <%= placedAt %></span>
      <% if (cancelled) { %>
        <span class="chip cancelled"><i class="fas fa-ban"></i> Cancelled</span>
      <% } else { %>
        <span class="chip eta"><i class="fas fa-motorcycle"></i> Arriving by <%= etaText %></span>
      <% } %>
    </div>
  </div>

  <div class="grid" style="margin-top:24px">

    <!-- LEFT -->
    <div>
      <% if (!cancelled) { %>
      <div class="card">
        <div class="card-title"><i class="fas fa-route"></i> Order Status</div>
        <div class="track">
          <div class="tstep <%= step>=1?"done":"" %> <%= step==1?"active":"" %>">
            <div class="tdot"><i class="fas fa-receipt"></i></div><div class="tlabel">Placed</div></div>
          <div class="tstep <%= step>=2?"done":"" %> <%= step==2?"active":"" %>">
            <div class="tdot"><i class="fas fa-kitchen-set"></i></div><div class="tlabel">Preparing</div></div>
          <div class="tstep <%= step>=3?"done":"" %> <%= step==3?"active":"" %>">
            <div class="tdot"><i class="fas fa-motorcycle"></i></div><div class="tlabel">On the way</div></div>
          <div class="tstep <%= step>=4?"done":"" %> <%= step==4?"active":"" %>">
            <div class="tdot"><i class="fas fa-house"></i></div><div class="tlabel">Delivered</div></div>
        </div>
      </div>
      <% } %>

      <div class="card">
        <div class="card-title"><i class="fas fa-location-dot"></i> Delivery Details</div>
        <div class="addr">
          <div class="addr-ic"><i class="fas fa-house"></i></div>
          <div>
            <div class="addr-name"><%= (user != null && user.getFullName() != null) ? user.getFullName() : "Delivery Address" %></div>
            <div class="addr-txt">
              <%= addr %>
              <% if (user != null && user.getPhoneNumber() != null && !user.getPhoneNumber().trim().isEmpty()) { %>
                <br><i class="fas fa-phone" style="font-size:11px;color:#bbb"></i> <%= user.getPhoneNumber() %>
              <% } %>
            </div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><i class="fas fa-bag-shopping"></i> <%= rName %> · <%= items.size() %> item<%= items.size()==1?"":"s" %></div>
        <% for (OrderItem item : items) {
             BigDecimal lt = item.getLineTotal() != null ? item.getLineTotal() : BigDecimal.ZERO;
             BigDecimal up = item.getUnitPrice() != null ? item.getUnitPrice() : BigDecimal.ZERO; %>
          <div class="item">
            <div class="item-icon"><i class="fas fa-utensils"></i></div>
            <div class="item-info">
              <div class="item-name"><%= item.getItemName() %></div>
              <div class="item-sub">&#8377;<%= up %> &times; <%= item.getQuantity() %></div>
            </div>
            <div class="item-amt">&#8377;<%= lt %></div>
          </div>
        <% } %>
      </div>

      <% if (cancellable) { %>
      <div class="card">
        <div class="card-title"><i class="fas fa-circle-xmark"></i> Cancel this order</div>
        <form method="post" action="<%= request.getContextPath() %>/cancel-order"
              onsubmit="return confirm('Cancel order #<%= order.getOrderId() %>? This cannot be undone.');">
          <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
          <label class="lbl" for="reason">Reason for cancellation</label>
          <select name="reason" id="reason" required>
            <option value="">Select a reason</option>
            <option value="Ordered by mistake">Ordered by mistake</option>
            <option value="Delivery taking too long">Delivery taking too long</option>
            <option value="Wrong delivery address">Wrong delivery address</option>
            <option value="Found a better offer">Found a better offer</option>
            <option value="Changed my mind">Changed my mind</option>
            <option value="Other">Other</option>
          </select>
          <button type="submit" class="btn btn-danger"><i class="fas fa-xmark"></i> Cancel Order</button>
          <p class="note">Free cancellation while the restaurant is still accepting the order. A confirmation email will be sent to you.</p>
        </form>
      </div>
      <% } %>
    </div>

    <!-- RIGHT: BILL -->
    <div class="bill">
      <div class="card">
        <div class="card-title"><i class="fas fa-receipt"></i> Bill Summary</div>
        <div class="brow"><span>Item total</span><span>&#8377;<%= subtotal %></span></div>
        <div class="brow"><span>Delivery fee</span><span>&#8377;<%= delFee %></span></div>
        <div class="brow"><span>Taxes &amp; charges</span><span>&#8377;<%= tax %></span></div>
        <div class="bdiv"></div>
        <div class="btotal"><span>Total Paid</span><span>&#8377;<%= total %></span></div>
        <div class="paid">
          <i class="fas fa-circle-check"></i>
          <%= (order.getPaymentMethod() != null && !order.getPaymentMethod().trim().isEmpty())
                ? order.getPaymentMethod() : "Cash on Delivery" %>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><i class="fas fa-headset"></i> Need help?</div>
        <p class="note" style="margin:0 0 14px">Issue with your order? Our support team replies within 5 minutes.</p>
        <button type="button" class="btn btn-ghost" style="margin-top:0" onclick="toggleChat()">
          <i class="fas fa-comment-dots"></i> Chat with Support
        </button>
        <a href="<%= request.getContextPath() %>/restaurants" style="text-decoration:none">
          <button type="button" class="btn btn-ghost"><i class="fas fa-plus"></i> Order Something Else</button>
        </a>
      </div>
    </div>

  </div>
</div>

<!-- CHAT -->
<div class="chat" id="chat">
  <div class="chat-h"><span><i class="fas fa-headset"></i> SwiftByte Support</span>
    <button type="button" onclick="toggleChat()"><i class="fas fa-xmark"></i></button></div>
  <div class="chat-b" id="chatBody">
    <div class="msg bot">Hi<%= (user != null && user.getFullName() != null) ? " " + user.getFullName() : "" %>! How can we help with order #<%= order.getOrderId() %>?</div>
  </div>
  <form class="chat-f" onsubmit="return sendMsg();">
    <input type="text" id="chatInput" placeholder="Type your message..." autocomplete="off">
    <button type="submit"><i class="fas fa-paper-plane"></i></button>
  </form>
</div>

<script>
  function toggleChat(){ document.getElementById('chat').classList.toggle('open'); }

  function sendMsg(){
    var i = document.getElementById('chatInput'), b = document.getElementById('chatBody');
    var v = i.value.trim(); if(!v) return false;
    function add(t,c){ var d=document.createElement('div'); d.className='msg '+c; d.textContent=t; b.appendChild(d); b.scrollTop=b.scrollHeight; }
    add(v,'me'); i.value='';
    setTimeout(function(){ add("Thanks for reaching out! An agent will respond within 5 minutes. For refunds, please allow 3-5 working days.",'bot'); }, 700);
    return false;
  }

  <% if (!cancelled) { %>
  (function(){
    var c = document.getElementById('cfx'), x = c.getContext('2d');
    c.width = innerWidth; c.height = innerHeight;
    var cols = ['#ff5722','#ffa270','#0f8a4f','#ffd166','#ef4e1c'], ps = [];
    for (var k=0;k<110;k++) ps.push({x:Math.random()*c.width,y:Math.random()*-c.height,r:Math.random()*6+3,
      d:Math.random()*40+10,col:cols[k%cols.length],tilt:Math.random()*10-10,ts:Math.random()*.12+.05,ta:0});
    var a = 0;
    function draw(){
      x.clearRect(0,0,c.width,c.height); a += .01;
      ps.forEach(function(p,i){
        p.y += (Math.cos(a+p.d) + 2 + p.r/2)/2; p.x += Math.sin(a)*1.6;
        p.ta += p.ts; p.tilt = Math.sin(p.ta)*12;
        if (p.y > c.height) { p.y = -12; p.x = Math.random()*c.width; }
        x.beginPath(); x.lineWidth = p.r/2; x.strokeStyle = p.col;
        x.moveTo(p.x + p.tilt + p.r/3, p.y);
        x.lineTo(p.x + p.tilt, p.y + p.tilt + p.r/2); x.stroke();
      });
      requestAnimationFrame(draw);
    }
    draw();
    setTimeout(function(){ c.style.display='none'; }, 4500);
  })();
  <% } %>
</script>
</body>
</html>
