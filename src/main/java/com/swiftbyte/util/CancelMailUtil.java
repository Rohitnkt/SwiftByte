package com.swiftbyte.util;

import java.math.BigDecimal;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class CancelMailUtil {

    private static final String FROM_EMAIL =  System.getenv("MAIL_USERNAME");    // same as OrderMailUtil
    private static final String FROM_PASSWORD =  System.getenv("MAIL_PASSWORD");  // 16-char Gmail app password

    public static void sendCancellationMail(String toEmail, String customerName,
                                            int orderId, BigDecimal total, String reason) {
        if (toEmail == null || toEmail.trim().isEmpty()) return;

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        String name = (customerName == null || customerName.trim().isEmpty()) ? "there" : customerName;
        String safeReason = (reason == null || reason.trim().isEmpty()) ? "Not specified" : reason;

        String html =
            "<div style=\"font-family:Segoe UI,Arial,sans-serif;background:#fff8f0;padding:28px;\">"
          + "  <div style=\"max-width:520px;margin:0 auto;background:#ffffff;border:1px solid #f0e4d6;"
          + "       border-radius:16px;overflow:hidden;\">"
          + "    <div style=\"background:#ff6b1a;padding:18px 22px;color:#ffffff;font-size:19px;font-weight:bold;\">SwiftByte</div>"
          + "    <div style=\"padding:24px 22px;color:#2b2b2b;\">"
          + "      <h2 style=\"margin:0 0 10px;font-size:20px;\">Your order has been cancelled</h2>"
          + "      <p style=\"margin:0 0 16px;color:#6f6a64;font-size:14px;\">Hi " + name + ", order "
          + "         <b>#" + orderId + "</b> has been cancelled as requested.</p>"
          + "      <table style=\"width:100%;font-size:14px;border-collapse:collapse;\">"
          + "        <tr><td style=\"padding:6px 0;color:#6f6a64;\">Order ID</td>"
          + "            <td style=\"padding:6px 0;text-align:right;font-weight:bold;\">#" + orderId + "</td></tr>"
          + "        <tr><td style=\"padding:6px 0;color:#6f6a64;\">Order amount</td>"
          + "            <td style=\"padding:6px 0;text-align:right;font-weight:bold;\">&#8377;"
          + String.format("%.2f", total) + "</td></tr>"
          + "        <tr><td style=\"padding:6px 0;color:#6f6a64;\">Reason</td>"
          + "            <td style=\"padding:6px 0;text-align:right;\">" + safeReason + "</td></tr>"
          + "      </table>"
          + "      <p style=\"margin:18px 0 0;font-size:13px;color:#6f6a64;\">If you paid online, the refund is"
          + "         initiated to your original payment method within 3-5 business days.</p>"
          + "      <p style=\"margin:16px 0 0;font-size:13px;color:#6f6a64;\">Hungry again? We're always here.</p>"
          + "    </div>"
          + "  </div>"
          + "</div>";

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL, "SwiftByte"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Order #" + orderId + " cancelled - SwiftByte");
            msg.setContent(html, "text/html; charset=UTF-8");
            Transport.send(msg);
        } catch (Exception e) {
            System.err.println("Cancellation mail failed: " + e.getMessage());
        }
    }

	
		
	}

