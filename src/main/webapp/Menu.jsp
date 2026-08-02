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

    Map<String, List<Menu>> grouped = new LinkedHashMap<>();
    for (Menu m : menus) {
        String cat = s(m.getCategory()).isEmpty() ? "Other" : m.getCategory();
        grouped.computeIfAbsent(cat, k -> new ArrayList<>()).add(m);
    }

    String cartFlag  = request.getParameter("cart");
    String cartError = request.getParameter("error");
    boolean loggedIn = (session.getAttribute("user") != null);

    String cartFlash = (String) session.getAttribute("flashMessage");
    if (cartFlash != null) session.removeAttribute("flashMessage");
    boolean cartFlashIsError = cartFlash != null
            && (cartFlash.startsWith("Could not") || cartFlash.startsWith("Missing")
                || cartFlash.toLowerCase().contains("only add"));
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= restaurant != null ? s(restaurant.getRestaurantName()) : "Menu" %> &mdash; Menu | SwiftByte</title>
<style>
  :root{
    --bg:#fcfbf8; --surface:#ffffff; --text:#1c1c1c; --muted:#6b6b6b;
    --primary:#fc8019; --primary-dark:#e6721a; --success:#3d9970; --danger:#e23744;
    --border:#ececec; --radius:16px; --shadow:0 4px 20px rgba(0,0,0,.06);
  }
  *{box-sizing:border-box;margin:0;padding:0;}
  body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;background:var(--bg);color:var(--text);line-height:1.5;}

  header{background:var(--surface);border-bottom:1px solid var(--border);padding:16px 24px;position:sticky;top:0;z-index:10;}
  .header-inner{max-width:1280px;margin:0 auto;display:flex;align-items:center;gap:16px;}
  .back{color:var(--primary);text-decoration:none;font-weight:600;font-size:14px;}
  .brand{font-size:22px;font-weight:800;color:var(--primary);}
  .header-spacer{flex:1;}
  .cart-link{color:var(--text);text-decoration:none;font-weight:700;font-size:14px;border:1px solid var(--border);padding:8px 14px;border-radius:10px;}
  .cart-link:hover{border-color:var(--primary);color:var(--primary);}

  .flash{max-width:900px;margin:16px auto 0;padding:12px 18px;border-radius:12px;font-size:14px;font-weight:600;}
  .flash-ok{background:#e8f6ef;color:var(--success);border:1px solid #bfe6d4;}
  .flash-err{background:#fdecee;color:var(--danger);border:1px solid #f6ccd1;}

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

  .menu-item{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:20px;margin-bottom:16px;display:flex;gap:20px;box-shadow:var(--shadow);transition:transform .2s;position:relative;}
  .menu-item:hover{transform:translateY(-2px);}

  .menu-item-info{flex:1;display:flex;flex-direction:column;min-width:0;}
  .item-name{font-size:17px;font-weight:700;margin-bottom:6px;}
  .item-price{font-size:15px;font-weight:600;color:var(--text);margin-bottom:8px;}
  .item-desc{font-size:14px;color:var(--muted);margin-bottom:10px;}
  .item-meta{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px;}
  .chip{font-size:12px;padding:3px 10px;border-radius:999px;font-weight:600;}
  .chip-cat{background:#fff4ec;color:var(--primary);}
  .chip-avail{background:#e8f6ef;color:var(--success);}
  .chip-unavail{background:#fdecee;color:var(--danger);}

  /* Swiggy-style image + ADD button wrapper */
  .img-wrap{position:relative;width:140px;height:140px;flex-shrink:0;}
  .menu-item-img{width:100%;height:100%;border-radius:12px;object-fit:cover;background:#eee;}

  /* Production-style Add button */
  .add-cart-form{
    position:absolute;
    left:50%;
    bottom:-14px;
    transform:translateX(-50%);
    z-index:2;
  }
  .add-cart-btn{
    background:#fff;color:var(--primary);border:none;
    font-family:inherit;font-size:13px;font-weight:800;letter-spacing:.4px;text-transform:uppercase;
    padding:8px 18px;border-radius:10px;cursor:pointer;white-space:nowrap;
    box-shadow:0 2px 10px rgba(0,0,0,.12), 0 0 0 1px rgba(0,0,0,.06);
    transition:transform .15s ease, box-shadow .15s ease, background .15s ease;
    display:inline-flex;align-items:center;gap:6px;
  }
  .add-cart-btn:hover{background:#fff7f2;transform:translateX(-50%) translateY(-1px);box-shadow:0 4px 14px rgba(252,128,25,.25), 0 0 0 1px rgba(252,128,25,.2);}
  .add-cart-btn:disabled{background:#f5f5f5;color:#999;cursor:not-allowed;box-shadow:0 2px 8px rgba(0,0,0,.08);}

  .login-order-btn{background:#fff;color:var(--primary);}

  .empty{text-align:center;padding:60px 20px;color:var(--muted);}

  @media(max-width:520px){
    .menu-item{flex-direction:column;}
    .img-wrap{width:100%;height:200px;margin-bottom:8px;}
    .menu-item-img{width:100%;height:100%;}
    .add-cart-form{bottom:10px;}
  }
</style>
</head>
<body>

<header>
  <div class="header-inner">
    <a class="back" href="<%= request.getContextPath() %>/restaurants">&larr; Back to restaurants</a>
    <div class="brand">SwiftByte</div>
    <div class="header-spacer"></div>
    <a class="cart-link" href="<%= request.getContextPath() %>/cart">&#128722; Cart</a>
  </div>
</header>

<% if (cartFlash != null) { %>
  <div class="flash <%= cartFlashIsError ? "flash-err" : "flash-ok" %>"><%= cartFlash %></div>
<% } %>
<% if ("added".equals(cartFlag)) { %>
  <div class="flash flash-ok">Item added to your cart.</div>
<% } else if ("updated".equals(cartFlag)) { %>
  <div class="flash flash-ok">Cart updated.</div>
<% } %>
<% if (cartError != null && !cartError.trim().isEmpty()) { %>
  <div class="flash flash-err"><%= s(cartError) %></div>
<% } %>

<% if (restaurant != null) { %>
<section class="hero">
  <div class="hero-inner">
    <% if (!s(restaurant.getImageUrl()).isEmpty()) { %>
      <img class="hero-img" src="<%= s(restaurant.getImageUrl()) %>" alt="<%= s(restaurant.getRestaurantName()) %>" />
    <% } %>
    <div class="hero-info">
      <h1><%= s(restaurant.getRestaurantName()) %></h1>
      <p><%= s(restaurant.getCuisineType()) %></p>
      <p><%= s(restaurant.getAddress()) %></p>
      <span class="hero-badge">&star; <%= String.format("%.1f", restaurant.getRating()) %></span>
    </div>
  </div>
</section>
<% } %>

<main class="container">
  <% if (menus.isEmpty()) { %>
    <div class="empty">
      <h3>No menu items available</h3>
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
            <div class="item-name"><%= s(m.getItemName()) %></div>
            <div class="item-price">&#8377;<%= String.format("%.2f", m.getPrice()) %></div>
            <% if (!s(m.getDescription()).isEmpty()) { %>
              <div class="item-desc"><%= s(m.getDescription()) %></div>
            <% } %>
            <div class="item-meta">
              <span class="chip chip-cat"><%= s(m.getCategory()) %></span>
              <% if (m.isAvailable()) { %>
                <span class="chip chip-avail">&#9679; Available</span>
              <% } else { %>
                <span class="chip chip-unavail">&#9679; Unavailable</span>
              <% } %>
            </div>
          </div>

          <div class="img-wrap">
            <% if (!s(m.getImageUrl()).isEmpty()) { %>
              <img class="menu-item-img" src="<%= s(m.getImageUrl()) %>" alt="<%= s(m.getItemName()) %>" />
            <% } %>

            <% if (loggedIn && restaurant != null) { %>
              <form class="add-cart-form" action="<%= request.getContextPath() %>/cart" method="post">
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="menuId" value="<%= m.getMenuId() %>" />
                <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>" />
                <input type="hidden" name="unitPrice" value="<%= m.getPrice() %>" />
                <button type="submit" class="add-cart-btn" <%= m.isAvailable() ? "" : "disabled" %>>
                  <%= m.isAvailable() ? "&#10010; ADD" : "Unavailable" %>
                </button>
              </form>
            <% } else if (restaurant != null) { %>
              <form class="add-cart-form" action="<%= request.getContextPath() %>/login.jsp" method="get">
                <button type="submit" class="add-cart-btn login-order-btn">&#10010; Login to Order</button>
              </form>
            <% } %>
          </div>
        </article>
      <% } %>
    </section>
  <%   }
     } %>
</main>

</body>
</html>
