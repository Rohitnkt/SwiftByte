<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.swiftbyte.model.Menu" %>
<%@ page import="com.swiftbyte.model.Restaurant" %>
<%!
    private String s(String v) { return (v == null || v.trim().isEmpty()) ? "" : v; }
%>
<%
    List<Menu> menus = (List<Menu>) request.getAttribute("menus");
    if (menus == null) menus = new ArrayList<>();
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");

    // Group menus by category
    Map<String, List<Menu>> grouped = new LinkedHashMap<>();
    for (Menu m : menus) {
        String cat = s(m.getCategory()).isEmpty() ? "Other" : m.getCategory();
        grouped.computeIfAbsent(cat, k -> new ArrayList<>()).add(m);
    }
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= restaurant != null ? s(restaurant.getRestaurantName()) : "Menu" %> — Menu | SwiftByte</title>
<style>
  :root{
    --bg:#fcfbf8; --surface:#ffffff; --text:#1c1c1c; --muted:#6b6b6b;
    --primary:#fc8019; --success:#3d9970; --danger:#e23744;
    --border:#ececec; --radius:16px; --shadow:0 4px 20px rgba(0,0,0,.06);
  }
  *{box-sizing:border-box;margin:0;padding:0;}
  body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;background:var(--bg);color:var(--text);line-height:1.5;}

  header{background:var(--surface);border-bottom:1px solid var(--border);padding:16px 24px;position:sticky;top:0;z-index:10;}
  .header-inner{max-width:1280px;margin:0 auto;display:flex;align-items:center;gap:16px;}
  .back{color:var(--primary);text-decoration:none;font-weight:600;font-size:14px;}
  .brand{font-size:22px;font-weight:800;color:var(--primary);}

  .hero{background:var(--surface);border-bottom:1px solid var(--border);}
  .hero-inner{max-width:1280px;margin:0 auto;padding:32px 24px;display:flex;gap:24px;align-items:center;flex-wrap:wrap;}
  .hero-img{width:160px;height:120px;border-radius:12px;object-fit:cover;background:#eee;}
  .hero-info h1{font-size:28px;margin-bottom:6px;}
  .hero-info p{color:var(--muted);font-size:14px;margin-bottom:4px;}
  .hero-badge{display:inline-flex;align-items:center;gap:4px;background:var(--success);color:#fff;padding:3px 8px;border-radius:6px;font-size:13px;font-weight:700;margin-top:6px;}

  .container{max-width:900px;margin:0 auto;padding:32px 24px;}
  .category{margin-bottom:40px;}
  .category-title{font-size:20px;font-weight:700;margin-bottom:16px;padding-bottom:8px;border-bottom:2px solid var(--border);}
  .category-count{color:var(--muted);font-size:14px;font-weight:500;margin-left:8px;}

  .menu-item{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:20px;margin-bottom:16px;display:flex;gap:20px;box-shadow:var(--shadow);transition:transform .2s;}
  .menu-item:hover{transform:translateY(-2px);}
  .menu-item-info{flex:1;}
  .item-name{font-size:17px;font-weight:700;margin-bottom:6px;}
  .item-price{font-size:15px;font-weight:600;color:var(--text);margin-bottom:8px;}
  .item-desc{font-size:14px;color:var(--muted);margin-bottom:10px;}
  .item-meta{display:flex;gap:8px;flex-wrap:wrap;}
  .chip{font-size:12px;padding:3px 10px;border-radius:999px;font-weight:600;}
  .chip-cat{background:#fff4ec;color:var(--primary);}
  .chip-avail{background:#e8f6ef;color:var(--success);}
  .chip-unavail{background:#fdecee;color:var(--danger);}

  .menu-item-img{width:120px;height:120px;border-radius:12px;object-fit:cover;background:#eee;flex-shrink:0;}
  .empty{text-align:center;padding:60px 20px;color:var(--muted);}

  @media(max-width:520px){
    .menu-item{flex-direction:column-reverse;}
    .menu-item-img{width:100%;height:180px;}
    .hero-img{width:100%;height:180px;}
  }
</style>
</head>
<body>

<header>
  <div class="header-inner">
    <a href="restaurants" class="back">← Back to restaurants</a>
    <div class="brand" style="margin-left:auto;">SwiftByte</div>
  </div>
</header>

<% if (restaurant != null) { %>
<section class="hero">
  <div class="hero-inner">
    <img class="hero-img"
         src="<%= s(restaurant.getImageUrl()).isEmpty() ? "https://via.placeholder.com/320x240?text=Restaurant" : restaurant.getImageUrl() %>"
         alt="<%= s(restaurant.getRestaurantName()) %>" />
    <div class="hero-info">
      <h1><%= s(restaurant.getRestaurantName()) %></h1>
      <p><%= s(restaurant.getCuisineType()) %></p>
      <p><%= s(restaurant.getAddress()) %></p>
      <span class="hero-badge">★ <%= String.format("%.1f", restaurant.getRating()) %></span>
    </div>
  </div>
</section>
<% } %>

<main class="container">
  <% if (menus.isEmpty()) { %>
    <div class="empty">
      <h2>No menu items available</h2>
      <p>This restaurant hasn't added any items yet.</p>
    </div>
  <% } else {
       for (Map.Entry<String, List<Menu>> entry : grouped.entrySet()) {
         String category = entry.getKey();
         List<Menu> items = entry.getValue();
  %>
    <section class="category">
      <h2 class="category-title">
        <%= s(category) %>
        <span class="category-count">(<%= items.size() %> items)</span>
      </h2>

      <% for (Menu m : items) { %>
        <article class="menu-item">
          <div class="menu-item-info">
            <h3 class="item-name"><%= s(m.getItemName()) %></h3>
            <div class="item-price">₹<%= String.format("%.2f", m.getPrice()) %></div>
            <% if (!s(m.getDescription()).isEmpty()) { %>
              <p class="item-desc"><%= s(m.getDescription()) %></p>
            <% } %>
            <div class="item-meta">
              <span class="chip chip-cat"><%= s(m.getCategory()) %></span>
              <% if (m.isAvailable()) { %>
                <span class="chip chip-avail">● Available</span>
              <% } else { %>
                <span class="chip chip-unavail">● Unavailable</span>
              <% } %>
            </div>
          </div>
          <% if (!s(m.getImageUrl()).isEmpty()) { %>
            <img class="menu-item-img" src="<%= m.getImageUrl() %>" alt="<%= s(m.getItemName()) %>" />
          <% } %>
        </article>
      <% } %>
    </section>
  <%   }
     } %>
</main>

</body>
</html>
