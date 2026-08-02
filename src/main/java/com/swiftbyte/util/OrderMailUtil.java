package com.swiftbyte.util;

import java.math.BigDecimal;
import java.util.Properties;

import com.swiftbyte.model.Order;
import com.swiftbyte.model.OrderItem;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Fresh mailer dedicated to order e-mails (independent of MailUtil used for password reset).
 * Requires jakarta.mail-2.x.jar + jakarta.activation on the classpath (WEB-INF/lib).
 *
 * Gmail: enable 2-step verification and use a 16-char App Password below.
 */
public final class OrderMailUtil {

    // ---------- CONFIGURE THESE ----------
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String FROM_EMAIL = System.getenv("MAIL_USERNAME");
    private static final String FROM_PASSWORD = System.getenv("MAIL_PASSWORD");
    private static final String FROM_NAME = "SwiftByte";
    // -------------------------------------

    private OrderMailUtil() { }

    /** Sends the order confirmation. Never throws - failure must not break order placement. */
    public static boolean sendOrderConfirmation(String toEmail, String customerName, Order order) {
        if (toEmail == null || toEmail.trim().isEmpty() || order == null) return false;
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                }
            });

            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail.trim()));
            msg.setSubject("Order #" + order.getOrderId() + " confirmed - SwiftByte");
            msg.setContent(buildHtml(customerName, order), "text/html; charset=UTF-8");

            Transport.send(msg);
            return true;
        } catch (Exception e) {
            System.err.println("[OrderMailUtil] Failed to send order mail: " + e.getMessage());
            return false;
        }
    }

    private static String buildHtml(String name, Order o) {
        StringBuilder rows = new StringBuilder();
        for (OrderItem oi : o.getItems()) {
            rows.append("<tr>")
                .append("<td style=\"padding:10px 0;border-bottom:1px solid #F1E9DF;color:#2B2118;font:14px Arial\">")
                .append(esc(oi.getItemName())).append(" <span style=\"color:#8A7A6B\">x").append(oi.getQuantity()).append("</span>")
                .append("</td>")
                .append("<td align=\"right\" style=\"padding:10px 0;border-bottom:1px solid #F1E9DF;color:#2B2118;font:bold 14px Arial\">")
                .append("&#8377;").append(fmt(oi.getLineTotal()))
                .append("</td></tr>");
        }

        return "<div style=\"background:#FFF8F1;padding:28px 12px;font-family:Arial,Helvetica,sans-serif\">"
          + "<div style=\"max-width:560px;margin:0 auto;background:#FFFFFF;border:1px solid #F1E4D6;border-radius:16px;overflow:hidden\">"
          + "<div style=\"background:#FF6B2C;padding:22px 26px\">"
          +   "<div style=\"color:#FFFFFF;font-size:22px;font-weight:bold;letter-spacing:-.4px\">SwiftByte</div>"
          +   "<div style=\"color:#FFE6D8;font-size:13px;margin-top:4px\">Order confirmed</div>"
          + "</div>"
          + "<div style=\"padding:26px\">"
          +   "<h1 style=\"margin:0 0 6px;font-size:20px;color:#2B2118\">Thanks" + (isBlank(name) ? "" : ", " + esc(name)) + "! &#127831;</h1>"
          +   "<p style=\"margin:0 0 18px;font-size:14px;color:#6B5C4E;line-height:1.6\">Your order <strong>#" + o.getOrderId()
          +     "</strong> has been placed" + (isBlank(o.getRestaurantName()) ? "" : " at <strong>" + esc(o.getRestaurantName()) + "</strong>")
          +     " and the kitchen is on it. Estimated arrival in <strong>30-40 minutes</strong>.</p>"
          +   "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\">" + rows + "</table>"
          +   "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin-top:14px\">"
          +     billRow("Item total", o.getSubtotal(), false)
          +     billRow("Delivery &amp; packaging", o.getDeliveryFee(), false)
          +     billRow("GST &amp; charges", o.getTax(), false)
          +     billRow("Total paid", o.getTotal(), true)
          +   "</table>"
          +   "<div style=\"margin-top:20px;background:#FFF8F1;border:1px dashed #FFC9AC;border-radius:12px;padding:14px 16px\">"
          +     "<div style=\"font-size:12px;color:#8A7A6B;text-transform:uppercase;letter-spacing:.6px\">Delivering to</div>"
          +     "<div style=\"font-size:14px;color:#2B2118;margin-top:4px;line-height:1.5\">" + esc(o.getDeliveryAddress()) + "</div>"
          +     "<div style=\"font-size:13px;color:#6B5C4E;margin-top:8px\">Payment: " + esc(o.getPaymentMethod()) + "</div>"
          +   "</div>"
          +   "<p style=\"margin:22px 0 0;font-size:12px;color:#9B8B7C\">Need help? Just reply to this e-mail.</p>"
          + "</div></div></div>";
    }

    private static String billRow(String label, BigDecimal amt, boolean strong) {
        String color = strong ? "#2B2118" : "#6B5C4E";
        String weight = strong ? "bold" : "normal";
        String border = strong ? "border-top:1px solid #F1E9DF;padding-top:10px;" : "";
        return "<tr><td style=\"" + border + "font:" + weight + " 14px Arial;color:" + color + ";padding:4px 0\">" + label + "</td>"
             + "<td align=\"right\" style=\"" + border + "font:bold 14px Arial;color:" + color + ";padding:4px 0\">&#8377;" + fmt(amt) + "</td></tr>";
    }

    private static String fmt(BigDecimal b) {
        return String.format("%.2f", b == null ? BigDecimal.ZERO : b);
    }

    private static boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
