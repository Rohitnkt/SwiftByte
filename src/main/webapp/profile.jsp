<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swiftbyte.model.*, java.util.*" %>
<%
    User u = (User) request.getAttribute("user");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>My profile • SwiftByte</title>
<style>
  body{margin:0;background:#fff7f0;color:#1c1c1c;font-family:'Segoe UI',system-ui,sans-serif}
  .nav{background:#fff;border-bottom:1px solid #f0e2d6;position:sticky;top:0}
  .nav-in{max-width:1000px;margin:0 auto;padding:12px 20px;display:flex;gap:12px;align-items:center}
  .brand{font-weight:800;color:#ff6a00;font-size:22px;text-decoration:none;margin-right:auto}
  .btn{padding:10px 16px;border-radius:10px;font-weight:700;font-size:14px;text-decoration:none;
       background:#ff6a00;color:#fff;border:0}
  .wrap{max-width:1000px;margin:26px auto;padding:0 20px}
  .card{background:#fff;border:1px solid #f0e2d6;border-radius:16px;padding:22px;margin-bottom:18px}
  h2{margin:0 0 14px;font-size:18px}
  .kv{display:flex;gap:10px;padding:8px 0;border-bottom:1px dashed #f0e2d6;font-size:14px}
  .kv span:first-child{width:170px;color:#6b6b6b;font-weight:600}
  table{width:100%;border-collapse:collapse;font-size:14px}
  th,td{text-align:left;padding:10px 8px;border-bottom:1px solid #f6ece3}
  th{color:#6b6b6b;font-size:12px;text-transform:uppercase;letter-spacing:.4px}
  .pill{padding:4px 10px;border-radius:999px;font-size:12px;font-weight:700;background:#fff1e6;color:#c25100}
</style>
</head>
<body>
<nav class="nav"><div class="nav-in">
  <a class="brand" href="<%= ctx %>/restaurants">SwiftByte</a>
  <a class="btn" href="<%= ctx %>/restaurants">Order Food</a>
</div></nav>

<div class="wrap">
  <div class="card">
    <h2>Account details</h2>
    <div class="kv"><span>Full name</span><span><%= u.getFullName() %></span></div>
    <div class="kv"><span>Email</span><span><%= u.getEmail() %></span></div>
    <div class="kv"><span>Phone</span><span><%= u.getPhoneNumber() %></span></div>
    <div class="kv"><span>Delivery address</span><span><%= u.getDeliveryAddress() %></span></div>
  </div>

  <div class="card">
    <h2>Order history</h2>
    <% if (orders == null || orders.isEmpty()) { %>
      <p style="color:#6b6b6b">No orders yet.</p>
    <% } else { %>
      <table>
        <tr><th>Order</th><th>Restaurant</th><th>Total</th><th>Status</th><th></th></tr>
        <% for (Order o : orders) { %>
          <tr>
            <td>#<%= o.getOrderId() %></td>
            <td><%= o.getRestaurantName() == null ? "-" : o.getRestaurantName() %></td>
            <td>&#8377;<%= o.getTotal() %></td>
            <td><span class="pill"><%= o.getStatus() %></span></td>
            <td><a href="<%= ctx %>/order-success?id=<%= o.getOrderId() %>">View</a></td>
          </tr>
        <% } %>
      </table>
    <% } %>
  </div>
</div>
</body>
</html>
