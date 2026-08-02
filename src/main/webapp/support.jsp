<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swiftbyte.model.User" %>
<%
    User user = (session != null) ? (User) session.getAttribute("user") : null;
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String orderId = request.getParameter("orderId");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError != null) session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support | SwiftByte</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #FF6B35;
            --primary-dark: #E85A2B;
            --primary-light: #FFF0EB;
            --bg: #FAF8F5;
            --card: #FFFFFF;
            --text: #1F1F1F;
            --text-light: #6B7280;
            --border: #E5E7EB;
            --success: #22C55E;
            --success-light: #DCFCE7;
            --error: #EF4444;
            --error-light: #FEE2E2;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            padding: 24px 16px;
        }

        .container {
            max-width: 560px;
            margin: 0 auto;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--text-light);
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .back-link:hover { color: var(--primary-dark); }

        .support-card {
            background: var(--card);
            border-radius: 24px;
            padding: 36px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.08);
        }

        .support-card h1 {
            font-size: 24px;
            margin-bottom: 8px;
        }

        .support-card p {
            color: var(--text-light);
            font-size: 14px;
            margin-bottom: 28px;
        }

        .flash {
            padding: 14px 18px;
            border-radius: 12px;
            font-size: 14px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .flash.success {
            background: var(--success-light);
            color: #166534;
        }

        .flash.error {
            background: var(--error-light);
            color: #991B1B;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text);
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: var(--primary);
        }

        .form-group textarea {
            min-height: 140px;
            resize: vertical;
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-submit:hover { background: var(--primary-dark); }

        .quick-links {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-top: 24px;
        }

        .quick-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 14px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: white;
            color: var(--text);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .quick-link:hover {
            border-color: var(--primary);
            color: var(--primary-dark);
        }

        @media (max-width: 480px) {
            .support-card { padding: 24px; }
            .quick-links { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="<%= request.getContextPath() %>/order-success<%= (orderId != null ? "?id=" + orderId : "") %>" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Order
        </a>

        <div class="support-card">
            <h1><i class="fas fa-headset" style="color: var(--primary); margin-right: 10px;"></i>Support</h1>
            <p>Tell us about your issue and we'll get back to you shortly.</p>

            <% if (flashSuccess != null) { %>
                <div class="flash success"><i class="fas fa-check-circle"></i> <%= flashSuccess %></div>
            <% } %>
            <% if (flashError != null) { %>
                <div class="flash error"><i class="fas fa-exclamation-circle"></i> <%= flashError %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/support" method="post">
                <input type="hidden" name="orderId" value="<%= orderId != null ? orderId : "" %>">

                <div class="form-group">
                    <label for="issueType">Issue Type</label>
                    <select name="issueType" id="issueType" required>
                        <option value="">Select an issue</option>
                        <option value="order_issue">Order Issue</option>
                        <option value="delivery_issue">Delivery Issue</option>
                        <option value="payment_issue">Payment Issue</option>
                        <option value="app_issue">App Issue</option>
                        <option value="other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea name="message" id="message" placeholder="Describe your issue in detail..." required></textarea>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-paper-plane" style="margin-right: 8px;"></i>Send Message
                </button>
            </form>

            <div class="quick-links">
                <a href="mailto:support@swiftbyte.com?subject=Support Request" class="quick-link">
                    <i class="fas fa-envelope"></i> Email Us
                </a>
                <a href="https://wa.me/919999999999?text=Hi%20SwiftByte%20support" target="_blank" class="quick-link">
                    <i class="fab fa-whatsapp"></i> WhatsApp
                </a>
            </div>
        </div>
    </div>
</body>
</html>
