<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.swiftbyte.model.Restaurant" %>
<%!
    private String fmtTime(java.sql.Time t) {
        if (t == null) return "";
        return new java.text.SimpleDateFormat("hh:mm a").format(t);
    }
    private String s(String v) { return (v == null || v.trim().isEmpty()) ? "" : v; }
%>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    if (restaurants == null) restaurants = new ArrayList<>();

    Set<String> cuisineSet = new TreeSet<>();
    for (Restaurant r : restaurants) {
        if (r.getCuisineType() != null) {
            for (String c : r.getCuisineType().split(",")) {
                String t = c.trim();
                if (!t.isEmpty()) cuisineSet.add(t);
            }
        }
    }

    Map<String,String> emojiMap = new HashMap<>();
    emojiMap.put("burgers","🍔"); emojiMap.put("burger","🍔");
    emojiMap.put("pizza","🍕"); emojiMap.put("pizzas","🍕"); emojiMap.put("italian","🍕");
    emojiMap.put("biryani","🍛"); emojiMap.put("north indian","🍛"); emojiMap.put("mughlai","🍛"); emojiMap.put("punjabi","🍛");
    emojiMap.put("south indian","🥘"); emojiMap.put("chettinad","🥘"); emojiMap.put("kerala","🥘");
    emojiMap.put("chinese","🥡"); emojiMap.put("japanese","🍱"); emojiMap.put("sushi","🍣");
    emojiMap.put("desserts","🍰"); emojiMap.put("bakery","🥐"); emojiMap.put("ice-cream","🍨"); emojiMap.put("ice cream","🍨");
    emojiMap.put("cafe","☕"); emojiMap.put("beverages","🥤");
    emojiMap.put("street food","🌮"); emojiMap.put("chaat","🌯");
    emojiMap.put("fast food","🍟"); emojiMap.put("seafood","🦐");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>SwiftByte - Restaurants</title>
<style>
  :root{
    --primary:#ff5200;--primary-dark:#e64a19;
    --text:#1c1c1c;--text-muted:#686b78;--text-light:#93959f;
    --border:#e9e9eb;--surface:#fff;--bg:#fff;
    --success:#48c479;--radius:16px;
  }
  *{margin:0;padding:0;box-sizing:border-box;}
  body{font-family:'Inter',system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:var(--bg);color:var(--text);line-height:1.5;-webkit-font-smoothing:antialiased;}
  a{text-decoration:none;color:inherit;}

  .navbar{background:var(--surface);box-shadow:0 2px 10px rgba(0,0,0,.05);position:sticky;top:0;z-index:100;}
  .nav-container{max-width:1280px;margin:0 auto;padding:0 24px;height:72px;display:flex;align-items:center;gap:40px;}
  .logo{display:flex;align-items:center;gap:10px;font-weight:900;color:var(--primary);font-size:22px;}
  .logo-icon{width:38px;height:38px;background:var(--primary);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:20px;}
  .location-pill{display:flex;align-items:center;gap:6px;font-weight:700;font-size:14px;border-bottom:2px solid var(--text);padding-bottom:2px;cursor:pointer;}
  .nav-links{margin-left:auto;display:flex;align-items:center;gap:36px;font-weight:600;font-size:15px;color:#3d4152;}
  .nav-links a{display:flex;align-items:center;gap:6px;transition:color .2s;}
  .nav-links a:hover{color:var(--primary);}

  .container{max-width:1280px;margin:0 auto;padding:32px 24px;}
  .section-title{font-size:24px;font-weight:800;margin-bottom:24px;letter-spacing:-.4px;}

  .cuisine-strip{display:flex;gap:24px;overflow-x:auto;padding-bottom:16px;scrollbar-width:none;}
  .cuisine-strip::-webkit-scrollbar{display:none;}
  .cuisine-item{flex:0 0 auto;text-align:center;cursor:pointer;transition:transform .2s;}
  .cuisine-item:hover{transform:translateY(-4px);}
  .cuisine-circle{width:120px;height:120px;border-radius:50%;background:linear-gradient(135deg,#fff4ec 0%,#ffe0cc 100%);display:flex;align-items:center;justify-content:center;font-size:56px;margin-bottom:8px;box-shadow:inset 0 -4px 12px rgba(0,0,0,.04);}
  .cuisine-name{font-size:15px;font-weight:700;color:var(--text);}

  .divider{border-top:2px dashed var(--border);margin:16px 0 32px;}

  .restaurant-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(273px,1fr));gap:32px 20px;}

  .card-link{display:block;color:inherit;}
  .card{cursor:pointer;transition:transform .3s ease;}
  .card-link:hover .card{transform:translateY(-4px);}
  .card-link:hover .card-image img{transform:scale(1.05);}
  .card-link:hover .card-title{color:var(--primary);}

  .card-image{position:relative;width:100%;aspect-ratio:16/10;border-radius:var(--radius);overflow:hidden;background:#f0f0f0;}
  .card-image img{width:100%;height:100%;object-fit:cover;transition:transform .4s ease;}
  .image-overlay{position:absolute;inset:0;background:linear-gradient(to top,rgba(0,0,0,.7) 0%,transparent 55%);}
  .promo-overlay{position:absolute;left:12px;bottom:10px;right:12px;color:#fff;font-weight:900;font-size:20px;text-shadow:0 2px 6px rgba(0,0,0,.4);line-height:1.1;}
  .top-chain-badge{position:absolute;top:12px;left:12px;background:rgba(255,255,255,.95);color:#3d1e00;padding:5px 10px;border-radius:6px;font-size:11px;font-weight:800;text-transform:uppercase;letter-spacing:.4px;}
  .status-pill{position:absolute;top:12px;right:12px;padding:4px 9px;border-radius:6px;font-size:11px;font-weight:800;text-transform:uppercase;}
  .status-open{background:var(--success);color:#fff;}
  .status-closed{background:#e53935;color:#fff;}

  .card-body{padding:14px 4px 0;}
  .card-title{font-size:18px;font-weight:700;color:var(--text);margin-bottom:6px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;transition:color .2s;}
  .rating-row{display:flex;align-items:center;gap:6px;font-size:15px;font-weight:700;margin-bottom:6px;}
  .rating-badge{display:inline-flex;align-items:center;justify-content:center;width:20px;height:20px;background:var(--success);color:#fff;border-radius:50%;font-size:11px;}
  .dot{color:var(--text-muted);}
  .meta{font-size:14px;color:var(--text-muted);}
  .meta-line{margin-top:4px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
  .address-line{font-size:13px;color:var(--text-light);margin-top:2px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
  .timings{font-size:13px;color:var(--text-light);margin-top:4px;}

  .no-results{grid-column:1/-1;text-align:center;padding:80px 24px;color:var(--text-muted);font-size:16px;}
  .footer{background:#f0f0f5;padding:32px 24px;text-align:center;color:var(--text-muted);font-size:14px;margin-top:48px;}

  @media(max-width:600px){
    .nav-links{gap:20px;font-size:13px;}
    .cuisine-circle{width:90px;height:90px;font-size:42px;}
    .section-title{font-size:20px;}
  }
</style>
</head>
<body>

<nav class="navbar">
  <div class="nav-container">
    <div class="logo"><div class="logo-icon">S</div> SwiftByte</div>
    <div class="location-pill">Bangalore ▾</div>
    <div class="nav-links">
      <a href="#">🔍 Search</a>
      <a href="#">🏷️ Offers</a>
      <a href="#">❓ Help</a>
      <a href="${pageContext.request.contextPath}/login.jsp" class="nav-item">
  <span>👤</span> Sign In
</a>
      
      <a href="#">🛒 Cart</a>
    </div>
  </div>
</nav>

<%
    String loginFlag = request.getParameter("login");
    if ("success".equals(loginFlag)) {
%>
  <div class="login-banner" style="
      background: #e6f7ea;
      color: #1b7a3e;
      padding: 12px 20px;
      border-radius: 12px;
      margin: 16px auto;
      max-width: 1200px;
      font-weight: 600;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 10px;">
    <span>✅</span>
    <span>Login successful! Welcome back to SwiftByte.</span>
  </div>
<%
    }
%>


<section class="container">
  <h2 class="section-title">What's on your mind?</h2>
  <div class="cuisine-strip">
    <%
      int shown = 0;
      for (String c : cuisineSet) {
          if (shown++ > 15) break;
          String key = c.toLowerCase();
          String emoji = emojiMap.getOrDefault(key, "🍽️");
    %>
      <div class="cuisine-item">
        <div class="cuisine-circle"><%= emoji %></div>
        <div class="cuisine-name"><%= c %></div>
      </div>
    <%
      }
      if (shown == 0) {
    %>
      <div class="cuisine-item">
        <div class="cuisine-circle">🍽️</div>
        <div class="cuisine-name">No cuisines yet</div>
      </div>
    <% } %>
  </div>

  <div class="divider"></div>

  <h2 class="section-title">Top restaurants near you</h2>
  <div class="restaurant-grid">
    <%
      if (restaurants.isEmpty()) {
    %>
      <div class="no-results">No restaurants available right now.</div>
    <%
      } else {
        for (Restaurant r : restaurants) {
            boolean open = r.isActive();
            String promo = s(r.getPromoOffer());
            String img = s(r.getImageUrl());
            if (img.isEmpty()) img = "https://via.placeholder.com/400x260?text=" + java.net.URLEncoder.encode(s(r.getRestaurantName()), "UTF-8");
    %>
      <a class="card-link" href="menu?restaurantId=<%= r.getRestaurantId() %>">
        <div class="card">
          <div class="card-image">
            <img src="<%= img %>" alt="<%= s(r.getRestaurantName()) %>" />
            <div class="image-overlay"></div>
            <% if (r.isTopChain()) { %>
              <div class="top-chain-badge">★ Top Chain</div>
            <% } %>
            <div class="status-pill <%= open ? "status-open" : "status-closed" %>">
              <%= open ? "Open" : "Closed" %>
            </div>
            <% if (!promo.isEmpty()) { %>
              <div class="promo-overlay"><%= promo %></div>
            <% } %>
          </div>

          <div class="card-body">
            <h3 class="card-title"><%= s(r.getRestaurantName()) %></h3>
            <div class="rating-row">
              <span class="rating-badge">★</span>
              <%= String.format("%.1f", r.getRating()) %>
              <span class="dot">•</span>
              <%= r.getDeliveryTimeLabel() %>
            </div>
            <% if (!s(r.getCuisineType()).isEmpty()) { %>
              <div class="meta meta-line"><%= r.getCuisineType() %></div>
            <% } %>
            <% if (!s(r.getAddress()).isEmpty()) { %>
              <div class="address-line"><%= r.getAddress() %></div>
            <% } %>
            <% if (r.getOpeningTime() != null && r.getClosingTime() != null) { %>
              <div class="timings">🕒 <%= fmtTime(r.getOpeningTime()) %> – <%= fmtTime(r.getClosingTime()) %></div>
            <% } %>
          </div>
        </div>
      </a>
    <%
        }
      }
    %>
  </div>
</section>

<footer class="footer">© 2026 SwiftByte. Crafted for premium food delivery.</footer>

</body>
</html>
