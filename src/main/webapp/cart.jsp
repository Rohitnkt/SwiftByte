<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.swiftbyte.model.CartItem" %>
<%@ page import="com.swiftbyte.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double grandTotalObj = (Double) request.getAttribute("grandTotal");
    double grandTotal = (grandTotalObj != null) ? grandTotalObj : 0.0;
    Integer restaurantId = (Integer) request.getAttribute("restaurantId");

    String flash = (String) session.getAttribute("flashMessage");
    if (flash != null) {
        session.removeAttribute("flashMessage");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart | SwiftByte</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #FF6B35;
            --primary-dark: #E85A24;
            --bg: #FFF8F3;
            --card: #FFFFFF;
            --text: #1F1F1F;
            --text-muted: #6B7280;
            --border: #E5E7EB;
            --success: #10B981;
            --danger: #EF4444;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        .container { max-width: 960px; margin: 0 auto; padding: 24px 16px; }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .header h1 { font-size: 28px; font-weight: 700; }

        .back-link {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }

        .flash {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        .flash.success { background: #D1FAE5; color: #065F46; }
        .flash.error { background: #FEE2E2; color: #991B1B; }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: var(--card);
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        }
        .empty-state h2 { font-size: 22px; margin-bottom: 10px; }
        .empty-state p { color: var(--text-muted); margin-bottom: 24px; }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-size: 15px;
            transition: background 0.2s ease;
        }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: var(--primary-dark); }
        .btn-outline { background: transparent; color: var(--danger); border: 1px solid var(--danger); }
        .btn-outline:hover { background: #FEF2F2; }
        .btn-sm { padding: 8px 14px; font-size: 13px; }

        .cart-card {
            background: var(--card);
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            overflow: hidden;
        }

        .restaurant-bar {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .restaurant-bar h2 { font-size: 18px; font-weight: 700; }
        .restaurant-bar span { color: var(--text-muted); font-size: 13px; }

        .cart-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
        }
        .cart-item:last-child { border-bottom: none; }

        .item-img {
            width: 80px;
            height: 80px;
            border-radius: 12px;
            object-fit: cover;
            background: #f3f4f6;
            flex-shrink: 0;
        }

        .item-info { flex: 1; }
        .item-info h3 { font-size: 16px; font-weight: 600; margin-bottom: 4px; }
        .item-info p { font-size: 13px; color: var(--text-muted); }

        .qty-control {
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 4px;
        }
        .qty-control button {
            width: 28px;
            height: 28px;
            border: none;
            background: var(--bg);
            border-radius: 6px;
            font-weight: 700;
            cursor: pointer;
            color: var(--text);
        }
        .qty-control span {
            min-width: 24px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
        }

        .item-price {
            text-align: right;
            min-width: 90px;
        }
        .item-price .unit { font-size: 13px; color: var(--text-muted); }
        .item-price .total { font-size: 16px; font-weight: 700; }

        .cart-footer {
            padding: 20px 24px;
            border-top: 1px solid var(--border);
            background: #FFFBF8;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 15px;
        }
        .summary-row.total {
            font-size: 18px;
            font-weight: 700;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px dashed var(--border);
        }

        .actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }
        .actions form { margin: 0; }
        .actions .btn { flex: 1; text-align: center; }

        @media (max-width: 640px) {
            .cart-item { flex-wrap: wrap; }
            .item-price { width: 100%; text-align: left; margin-top: 8px; }
            .actions { flex-direction: column; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Your Cart</h1>
        <a href="<%= request.getContextPath() %>/restaurants" class="back-link">← Browse restaurants</a>
    </div>

    <% if (flash != null) { %>
        <div class="flash <%= (flash.startsWith("Could not") || flash.startsWith("Missing") || flash.toLowerCase().contains("only add")) ? "error" : "success" %>">
            <%= flash %>
        </div>
    <% } %>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
        <div class="empty-state">
            <h2>Your cart is empty</h2>
            <p>Looks like you haven't added anything yet.</p>
            <a href="<%= request.getContextPath() %>/restaurants" class="btn btn-primary">Browse Restaurants</a>
        </div>
    <% } else { %>
        <div class="cart-card">
            <div class="restaurant-bar">
                <div>
                    <h2>Order Summary</h2>
                    <span><%= cartItems.size() %> item<%= cartItems.size() > 1 ? "s" : "" %></span>
                </div>
                <form action="<%= request.getContextPath() %>/cart" method="post" onsubmit="return confirm('Clear entire cart?');">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="btn btn-outline btn-sm">Clear Cart</button>
                </form>
            </div>

            <% for (CartItem item : cartItems) { %>
                <div class="cart-item">
                    <img src="<%= item.getImageUrl() != null && !item.getImageUrl().isEmpty() ? item.getImageUrl() : "https://via.placeholder.com/80" %>"
                         alt="<%= item.getItemName() %>"
                         class="item-img">
                    <div class="item-info">
                        <h3><%= item.getItemName() %></h3>
                        <p>₹<%= String.format("%.2f", item.getUnitPrice()) %> each</p>
                    </div>

                    <form action="<%= request.getContextPath() %>/cart" method="post" class="qty-control">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                        <input type="hidden" name="unitPrice" value="<%= item.getUnitPrice() %>">

                        <button type="submit" name="quantity" value="<%= item.getQuantity() - 1 %>">−</button>
                        <span><%= item.getQuantity() %></span>
                        <button type="submit" name="quantity" value="<%= item.getQuantity() + 1 %>">+</button>
                    </form>

                    <div class="item-price">
                        <div class="total">₹<%= String.format("%.2f", item.getTotalPrice()) %></div>
                    </div>

                    <form action="<%= request.getContextPath() %>/cart" method="post">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                        <button type="submit" class="btn btn-outline btn-sm">Remove</button>
                    </form>
                </div>
            <% } %>

            <div class="cart-footer">
                <div class="summary-row total">
                    <span>Grand Total</span>
                    <span>₹<%= String.format("%.2f", grandTotal) %></span>
                </div>

                <div class="actions">
                    <a href="<%= request.getContextPath() %>/checkout" class="btn btn-primary">Proceed to Checkout</a>
                    <% if (restaurantId != null) { %>
                        <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurantId %>" class="btn btn-outline" style="border-color: var(--primary); color: var(--primary);">Add More Items</a>
                    <% } %>
                </div>
            </div>
        </div>
    <% } %>
</div>

</body>
</html>
