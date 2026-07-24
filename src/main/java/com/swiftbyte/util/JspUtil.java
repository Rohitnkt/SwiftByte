package com.swiftbyte.util;

import java.sql.Time;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;

public final class JspUtil {

    private JspUtil() {
    }

    public static String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    public static String formatRating(double rating) {
        return String.format("%.1f", rating);
    }

    public static String formatCurrency(double amount) {
        NumberFormat numberFormat = NumberFormat.getNumberInstance(new Locale("en", "IN"));
        numberFormat.setMaximumFractionDigits(0);
        numberFormat.setMinimumFractionDigits(0);
        return "₹" + numberFormat.format(amount);
    }

    public static String defaultIfBlank(String value, String fallback) {
        return hasText(value) ? value.trim() : fallback;
    }

    public static boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static String formatTime(Time time) {
        if (time == null) {
            return "Flexible hours";
        }
        return new SimpleDateFormat("hh:mm a", Locale.ENGLISH).format(time);
    }

    public static String initials(String value) {
        if (!hasText(value)) {
            return "SB";
        }

        String[] parts = value.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase(Locale.ENGLISH);
        }

        StringBuilder builder = new StringBuilder();
        for (String part : parts) {
            if (!part.isEmpty()) {
                builder.append(Character.toUpperCase(part.charAt(0)));
            }
            if (builder.length() == 2) {
                break;
            }
        }
        return builder.length() > 0 ? builder.toString() : "SB";
    }

    public static String slugify(String value) {
        if (!hasText(value)) {
            return "section";
        }
        return value.trim()
                .toLowerCase(Locale.ENGLISH)
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-+|-+$", "");
    }

    public static String resolveImageUrl(String contextPath, String imageUrl) {
        if (!hasText(imageUrl)) {
            return "";
        }

        String trimmed = imageUrl.trim();
        if (trimmed.startsWith("http://") || trimmed.startsWith("https://") || trimmed.startsWith("data:")) {
            return trimmed;
        }

        if (trimmed.startsWith("/")) {
            return contextPath + trimmed;
        }

        return contextPath + "/" + trimmed;
    }
}
