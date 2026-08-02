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
    double itemTotal = (grandTotalObj != null) ? grandTotalObj.doubleValue() : 0.0;
    Integer restaurantId = (Integer) request.getAttribute("restaurantId");

    // Production-style bill breakdown
    double deliveryFee = (itemTotal >= 499.0 || itemTotal == 0.0) ? 0.0 : 39.0;
    double packagingFee = (itemTotal > 0.0) ? 20.0 : 0.0;
    double gst         = itemTotal * 0.05;
    double payable     = itemTotal + deliveryFee + packagingFee + gst;

    String flash = (String) session.getAttribute("flashMessage");
    if (flash != null) {
        session.removeAttribute("flashMessage");
    }

    String flashError = (String) session.getAttribute("flashError");
    if (flashError != null) {
        session.removeAttribute("flashError");
    }

    String custName    = (user.getFullName() != null) ? user.getFullName() : "Customer";
    String custPhone   = (user.getPhoneNumber() != null && !user.getPhoneNumber().trim().isEmpty()) ? user.getPhoneNumber() : "Not provided";
    String custAddress = (user.getDeliveryAddress() != null && !user.getDeliveryAddress().trim().isEmpty()) ? user.getDeliveryAddress() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | SwiftByte</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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
            --shadow: 0 4px 24px rgba(31,31,31,0.06);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); }

        .topbar {
            background: var(--card);
            border-bottom: 1px solid var(--border);
            padding: 16px 0;
            position: sticky; top: 0; z-index: 20;
        }
        .topbar-inner {
            max-width: 1060px; margin: 0 auto; padding: 0 16px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .brand { font-size: 20px; font-weight: 800; color: var(--primary); text-decoration: none; letter-spacing: -0.4px; }
        .back-link { color: var(--primary); text-decoration: none; font-weight: 600; font-size: 14px; }

        .container { max-width: 1060px; margin: 0 auto; padding: 28px 16px 64px; }

        .page-title { font-size: 28px; font-weight: 800; letter-spacing: -0.6px; }
        .page-sub { color: var(--text-muted); font-size: 14px; margin-top: 6px; }

        .steps { display: flex; gap: 10px; align-items: center; margin: 20px 0 26px; flex-wrap: wrap; }
        .step { display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 600; color: var(--text-muted); }
        .step .dot {
            width: 22px; height: 22px; border-radius: 50%;
            display: grid; place-items: center;
            background: #F1F1F1; color: var(--text-muted); font-size: 12px;
        }
        .step.done .dot { background: var(--success); color: #fff; }
        .step.active { color: var(--text); }
        .step.active .dot { background: var(--primary); color: #fff; }
        .step-line { flex: 0 0 28px; height: 2px; background: var(--border); }

        .flash { padding: 14px 18px; border-radius: 10px; margin-bottom: 20px; font-size: 14px; font-weight: 500; }
        .flash.success { background: #D1FAE5; color: #065F46; }
        .flash.error { background: #FEE2E2; color: #991B1B; }

        .grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 22px; align-items: start; }

        .card {
            background: var(--card); border-radius: 16px;
            box-shadow: var(--shadow); overflow: hidden; margin-bottom: 20px;
        }
        .card-head {
            padding: 18px 22px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
        }
        .card-head h2 { font-size: 17px; font-weight: 700; }
        .card-body { padding: 20px 22px; }

        .addr-name { font-weight: 700; font-size: 15px; margin-bottom: 6px; }
        .addr-text { color: var(--text-muted); font-size: 14px; line-height: 1.6; }
        .addr-missing {
            background: #FEF3C7; color: #92400E; padding: 12px 14px;
            border-radius: 10px; font-size: 13.5px; font-weight: 500;
        }

        .pay-option {
            display: flex; align-items: center; gap: 14px;
            border: 1.5px solid var(--border); border-radius: 12px;
            padding: 14px 16px; margin-bottom: 12px; cursor: pointer;
            transition: border-color .15s ease, background .15s ease;
        }
        .pay-option:hover { border-color: #FFCDB8; background: #FFFBF8; }
        .pay-option input { accent-color: var(--primary); width: 18px; height: 18px; }
        .pay-option .label { font-weight: 600; font-size: 14.5px; }
        .pay-option .hint { color: var(--text-muted); font-size: 12.5px; margin-top: 2px; }
        .pay-option.disabled { opacity: .55; cursor: not-allowed; }
        .badge-soon {
            margin-left: auto; font-size: 11px; font-weight: 700;
            background: #F3F4F6; color: var(--text-muted);
            padding: 4px 8px; border-radius: 999px; text-transform: uppercase; letter-spacing: .4px;
        }

        .line { display: flex; align-items: center; gap: 14px; padding: 14px 0; border-bottom: 1px solid var(--border); }
        .line:last-child { border-bottom: none; }
        .line img { width: 54px; height: 54px; border-radius: 10px; object-fit: cover; background: #F3F4F6; flex-shrink: 0; }
        .line .meta { flex: 1; }
        .line .meta h3 { font-size: 14.5px; font-weight: 600; }
        .line .meta p { font-size: 12.5px; color: var(--text-muted); margin-top: 2px; }
        .line .amt { font-weight: 700; font-size: 14.5px; white-space: nowrap; }

        .bill-row { display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 12px; color: var(--text-muted); }
        .bill-row strong { color: var(--text); font-weight: 600; }
        .bill-row.free strong { color: var(--success); }
        .bill-total {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 18px; font-weight: 800; margin-top: 16px;
            padding-top: 16px; border-top: 1px dashed var(--border);
        }

        .btn {
            display: block; width: 100%; text-align: center;
            padding: 14px 20px; border-radius: 12px; font-weight: 700;
            font-size: 15px; border: none; cursor: pointer; text-decoration: none;
            transition: background .15s ease, transform .05s ease;
            font-family: inherit;
        }
        .btn-primary { background: var(--primary); color: #fff; box-shadow: 0 6px 18px rgba(255,107,53,.28); }
        .btn-primary:hover { background: var(--primary-dark); }
        .btn-primary:active { transform: translateY(1px); }
        .btn-primary:disabled {
            background: #FDBA8C;
            cursor: not-allowed;
            box-shadow: none;
        }
        .btn-ghost { background: transparent; color: var(--primary); border: 1.5px solid var(--primary); margin-top: 10px; }
        .btn-ghost:hover { background: #FFF3ED; }

        .secure-note {
            margin-top: 14px; font-size: 12.5px; color: var(--text-muted);
            text-align: center; line-height: 1.6;
        }

        .sticky-side { position: sticky; top: 92px; }

        @media (max-width: 900px) {
            .grid { grid-template-columns: 1fr; }
            .sticky-side { position: static; }
        }
    </style>
</head>
<body>

    <div class="topbar">
        <div class="topbar-inner">
            <a href="<%= request.getContextPath() %>/restaurants" class="brand">SwiftByte</a>
            <a href="<%= request.getContextPath() %>/cart" class="back-link">&larr; Back to cart</a>
        </div>
    </div>

    <div class="container">
        <h1 class="page-title">Checkout</h1>
        <p class="page-sub">Review your order, confirm your delivery address and place it.</p>

        <div class="steps">
            <div class="step done">
                <span class="dot">&#10003;</span>
                <span>Cart</span>
            </div>
            <div class="step-line"></div>
            <div class="step active">
                <span class="dot">2</span>
                <span>Checkout</span>
            </div>
            <div class="step-line"></div>
            <div class="step">
                <span class="dot">3</span>
                <span>Order placed</span>
            </div>
        </div>

        <% if (flash != null) { %>
            <div class="flash success"><%= flash %></div>
        <% } %>

        <% if (flashError != null) { %>
            <div class="flash error"><%= flashError %></div>
        <% } %>

        <div class="grid">
            <div>
                <!-- Delivery Address -->
                <div class="card">
                    <div class="card-head">
                        <h2>Delivery Address</h2>
                        <a href="#" style="color: var(--primary); font-size: 13.5px; font-weight: 600; text-decoration: none;">Change</a>
                    </div>
                    <div class="card-body">
                        <div class="addr-name"><%= custName %> &nbsp;&middot;&nbsp; <%= custPhone %></div>
                        <% if (custAddress.isEmpty()) { %>
                            <div class="addr-missing">No delivery address saved on your account. Please add one before placing the order.</div>
                        <% } else { %>
                            <div class="addr-text"><%= custAddress %></div>
                        <% } %>
                    </div>
                </div>

                <!-- Payment Method -->
                <div class="card">
                    <div class="card-head">
                        <h2>Payment Method</h2>
                    </div>
                    <div class="card-body">
                        <label class="pay-option">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <div>
                                <div class="label">Cash on Delivery</div>
                                <div class="hint">Pay the delivery partner when your food arrives</div>
                            </div>
                        </label>
                        <label class="pay-option disabled">
                            <input type="radio" name="paymentMethod" value="UPI" disabled>
                            <div>
                                <div class="label">UPI</div>
                                <div class="hint">GPay, PhonePe, Paytm</div>
                            </div>
                            <span class="badge-soon">Soon</span>
                        </label>
                        <label class="pay-option disabled">
                            <input type="radio" name="paymentMethod" value="CARD" disabled>
                            <div>
                                <div class="label">Credit / Debit Card</div>
                                <div class="hint">Visa, Mastercard, RuPay</div>
                            </div>
                            <span class="badge-soon">Soon</span>
                        </label>
                    </div>
                </div>

                <!-- Your Order -->
                <div class="card">
                    <div class="card-head">
                        <h2>Your Order</h2>
                        <% if (restaurantId != null) { %>
                            <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurantId %>" style="color: var(--primary); font-size: 13.5px; font-weight: 600; text-decoration: none;">Add more</a>
                        <% } %>
                    </div>
                    <div class="card-body">
                        <% if (cartItems != null) {
                               for (CartItem item : cartItems) { %>
                            <div class="line">
                                <img src="<%= (item.getImageUrl() != null && !item.getImageUrl().trim().isEmpty()) ? item.getImageUrl() : "https://via.placeholder.com/54?text=Food" %>"
                                     alt="<%= item.getItemName() %>">
                                <div class="meta">
                                    <h3><%= item.getItemName() %></h3>
                                    <p><%= item.getQuantity() %> &#215; &#8377;<%= String.format("%.2f", item.getUnitPrice()) %></p>
                                </div>
                                <div class="amt">&#8377;<%= String.format("%.2f", item.getTotalPrice()) %></div>
                            </div>
                        <%     }
                           } %>
                    </div>
                </div>
            </div>

            <div class="sticky-side">
                <div class="card">
                    <div class="card-head">
                        <h2>Bill Details</h2>
                    </div>
                    <div class="card-body">
                        <div class="bill-row">
                            <span>Item total</span>
                            <span>&#8377;<%= String.format("%.2f", itemTotal) %></span>
                        </div>
                        <div class="bill-row <%= deliveryFee == 0.0 ? "free" : "" %>">
                            <span>Delivery fee</span>
                            <strong><%= deliveryFee == 0.0 ? "FREE" : "&#8377;" + String.format("%.2f", deliveryFee) %></strong>
                        </div>
                        <div class="bill-row">
                            <span>Packaging charge</span>
                            <span>&#8377;<%= String.format("%.2f", packagingFee) %></span>
                        </div>
                        <div class="bill-row">
                            <span>GST &amp; restaurant charges</span>
                            <span>&#8377;<%= String.format("%.2f", gst) %></span>
                        </div>

                        <div class="bill-total">
                            <span>To Pay</span>
                            <span>&#8377;<%= String.format("%.2f", payable) %></span>
                        </div>

                        <form method="post" action="<%= request.getContextPath() %>/place-order" style="margin-top: 18px;">
                            <input type="hidden" name="paymentMethod" value="COD" />
                            <button type="submit" class="btn btn-primary"
                                    <%= custAddress.trim().isEmpty() ? "disabled" : "" %>>
                                Place Order &middot; &#8377;<%= String.format("%.2f", payable) %>
                            </button>
                        </form>

                        <a href="<%= request.getContextPath() %>/cart" class="btn btn-ghost">Edit Cart</a>

                        <p class="secure-note">
                            By placing this order you agree to SwiftByte's terms.<br>
                            <%= deliveryFee == 0.0 ? "Free delivery applied on this order." : "Add &#8377;" + String.format("%.2f", 499.0 - itemTotal) + " more for free delivery." %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
