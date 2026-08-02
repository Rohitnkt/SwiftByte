<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="com.swiftbyte.model.Restaurant" %>
<%!
    public String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
                .replace("\"","&quot;").replace("'","&#39;");
    }
    public String fmtTime(java.sql.Time t) {
        if (t == null) return "--";
        return new java.text.SimpleDateFormat("h:mm a").format(t);
    }
    public boolean isOpenNow(Restaurant r) {
        if (r == null) return false;
        java.sql.Time open = r.getOpeningTime();
        java.sql.Time close = r.getClosingTime();
        if (open == null || close == null) return false;
        java.util.Calendar now = java.util.Calendar.getInstance();
        java.util.Calendar o = java.util.Calendar.getInstance(); o.setTime(open);
        java.util.Calendar c = java.util.Calendar.getInstance(); c.setTime(close);
        int nowMin  = now.get(java.util.Calendar.HOUR_OF_DAY)*60 + now.get(java.util.Calendar.MINUTE);
        int openMin = o.get(java.util.Calendar.HOUR_OF_DAY)*60 + o.get(java.util.Calendar.MINUTE);
        int closeMin= c.get(java.util.Calendar.HOUR_OF_DAY)*60 + c.get(java.util.Calendar.MINUTE);
        if (closeMin < openMin) return nowMin >= openMin || nowMin <= closeMin;
        return nowMin >= openMin && nowMin <= closeMin;
    }
%>
<%
    String ctx = request.getContextPath();

    List<Restaurant> all = (List<Restaurant>) request.getAttribute("restaurants");
    if (all == null) all = Collections.emptyList();

    String q        = request.getParameter("q");
    String cuisine  = request.getParameter("cuisine");
    String openOnly = request.getParameter("openOnly");
    if (q == null) q = "";
    if (cuisine == null) cuisine = "";
    boolean onlyOpen = "1".equals(openOnly) || "true".equalsIgnoreCase(openOnly);

    String qLower = q.trim().toLowerCase();
    String cLower = cuisine.trim().toLowerCase();

    List<Restaurant> filtered = new ArrayList<Restaurant>();
    for (Restaurant r : all) {
        if (r == null) continue;
        String name = r.getRestaurantName() == null ? "" : r.getRestaurantName();
        String cui  = r.getCuisineType()    == null ? "" : r.getCuisineType();
        String addr = r.getAddress()        == null ? "" : r.getAddress();
        if (!qLower.isEmpty()
            && !name.toLowerCase().contains(qLower)
            && !cui.toLowerCase().contains(qLower)
            && !addr.toLowerCase().contains(qLower)) continue;
        if (!cLower.isEmpty() && !cui.toLowerCase().contains(cLower)) continue;
        if (onlyOpen && !isOpenNow(r)) continue;
        filtered.add(r);
    }

    int pageSize = 8;
    try {
        String ps = request.getParameter("size");
        if (ps != null && !ps.trim().isEmpty()) pageSize = Integer.parseInt(ps.trim());
    } catch (Exception ignore) {}
    if (pageSize < 4) pageSize = 4;
    if (pageSize > 48) pageSize = 48;

    int total = filtered.size();
    int totalPages = (total == 0) ? 1 : (int) Math.ceil(total / (double) pageSize);

    int pageNo = 1;
    try {
        String pn = request.getParameter("page");
        if (pn != null && !pn.trim().isEmpty()) pageNo = Integer.parseInt(pn.trim());
    } catch (Exception ignore) {}
    if (pageNo < 1) pageNo = 1;
    if (pageNo > totalPages) pageNo = totalPages;

    int fromIndex = (pageNo - 1) * pageSize;
    int toIndex   = Math.min(fromIndex + pageSize, total);
    List<Restaurant> pageItems = (fromIndex >= total)
            ? Collections.<Restaurant>emptyList() : filtered.subList(fromIndex, toIndex);

    StringBuilder baseQs = new StringBuilder();
    if (!q.trim().isEmpty())
        baseQs.append("&q=").append(URLEncoder.encode(q.trim(), StandardCharsets.UTF_8.name()));
    if (!cuisine.trim().isEmpty())
        baseQs.append("&cuisine=").append(URLEncoder.encode(cuisine.trim(), StandardCharsets.UTF_8.name()));
    if (onlyOpen) baseQs.append("&openOnly=1");
    if (pageSize != 8) baseQs.append("&size=").append(pageSize);
    String filtersQs = baseQs.toString();

    LinkedHashMap<String,String> cuisines = new LinkedHashMap<String,String>();
    String CDN = "https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_208,h_208,c_fit/PC_Mweb/";
    cuisines.put("Biryani",       CDN + "Biryani.png");
    cuisines.put("Pizza",         CDN + "Pizza.png");
    cuisines.put("Burger",        CDN + "Burger.png");
    cuisines.put("North Indian",  CDN + "North_Indian.png");
    cuisines.put("South Indian",  CDN + "Dosa.png");
    cuisines.put("Chinese",       CDN + "Chinese.png");
    cuisines.put("Rolls",         CDN + "Rolls.png");
    cuisines.put("Cake",          CDN + "Cake.png");
    cuisines.put("Ice Cream",     CDN + "Ice_Cream.png");
    cuisines.put("Shawarma",      CDN + "Shawarma.png");

    String fallbackImg = "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=70";
    boolean loggedIn = (session.getAttribute("user") != null);

    String flash = (String) session.getAttribute("flash");
    if (flash != null) session.removeAttribute("flash");
    if ("success".equals(request.getParameter("login"))) flash = "Login successful. Welcome back!";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>SwiftByte — Order food online</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<style>
:root{--brand:#ff5200;--brand-dark:#d94300;--ink:#02060c;--muted:#6b7280;
--line:#eceef1;--bg:#fff;--soft:#fff8f4;--radius:18px;--shadow:0 8px 24px rgba(2,6,12,.08)}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);font-family:'Segoe UI',system-ui,-apple-system,Roboto,Arial,sans-serif}
a{text-decoration:none;color:inherit}
.wrap{max-width:1200px;margin:0 auto;padding:0 20px}
.nav{position:sticky;top:0;z-index:60;background:#fff;border-bottom:1px solid var(--line);box-shadow:0 2px 10px rgba(2,6,12,.04)}
.nav-in{display:flex;align-items:center;gap:20px;height:74px}
.logo{display:flex;align-items:center;gap:10px;font-weight:900;font-size:22px;letter-spacing:-.5px}
.logo i{color:var(--brand)}
.nav-form{flex:1;min-width:0;display:flex;align-items:center;gap:10px}
.nav-search{flex:1;min-width:0;display:flex;align-items:center;gap:10px;border:1px solid var(--line);border-radius:12px;padding:10px 14px;background:#fafafa}
.nav-search i{color:var(--muted)}
.nav-search input{flex:1;min-width:0;border:0;outline:0;background:transparent;font-size:15px}
.toggle{display:flex;align-items:center;gap:7px;font-weight:700;font-size:13px;color:var(--muted);white-space:nowrap}
.nav-links{display:flex;align-items:center;gap:20px;font-weight:700;font-size:15px;white-space:nowrap}
.nav-links a:hover{color:var(--brand)}
.btn-primary{background:var(--brand);color:#fff;border:0;border-radius:12px;padding:11px 20px;font-weight:800;font-size:14px;cursor:pointer}
.btn-primary:hover{background:var(--brand-dark)}
.section{padding:34px 0;border-bottom:1px solid var(--line)}
h2{font-size:26px;margin:0 0 18px;letter-spacing:-.6px}
.strip{display:flex;gap:26px;overflow-x:auto;padding:6px 2px 14px}
.cuisine{flex:0 0 auto;text-align:center;width:112px}
.cuisine-circle{width:104px;height:104px;border-radius:50%;overflow:hidden;border:3px solid transparent;background:radial-gradient(circle at 50% 30%,#fff1e8,#fff);display:grid;place-items:center}
.cuisine img{width:100%;height:100%;object-fit:contain}
.cuisine.active .cuisine-circle{border-color:var(--brand);box-shadow:0 8px 20px rgba(255,82,0,.28)}
.cuisine-label{display:block;margin-top:10px;font-size:14px;font-weight:800}
.chip-clear{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--line);border-radius:999px;padding:8px 14px;font-weight:700;font-size:13px;background:var(--soft);color:var(--brand)}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(258px,1fr));gap:26px}
.card{border-radius:var(--radius);overflow:hidden;background:#fff;border:1px solid var(--line);transition:transform .18s ease,box-shadow .18s ease;display:flex;flex-direction:column}
.card:hover{transform:translateY(-4px);box-shadow:var(--shadow)}
.card-media{position:relative;aspect-ratio:4/3;background:#f3f4f6}
.card-media img{width:100%;height:100%;object-fit:cover;display:block}
.badge{position:absolute;top:12px;left:12px;background:rgba(2,6,12,.72);color:#fff;padding:5px 10px;border-radius:999px;font-size:11px;font-weight:800;letter-spacing:.4px}
.badge.closed{background:rgba(185,28,28,.86)}
.add-form{position:absolute;bottom:-16px;right:14px;margin:0}
.add-btn{background:#fff;color:var(--brand);border:1px solid #ffd0b8;border-radius:12px;padding:10px 18px;font-weight:900;font-size:13px;letter-spacing:.4px;cursor:pointer;box-shadow:0 6px 16px rgba(2,6,12,.12)}
.add-btn:hover{background:var(--brand);color:#fff;border-color:var(--brand)}
.card-body{padding:24px 16px 18px;display:flex;flex-direction:column;gap:6px}
.card-title{font-size:17px;font-weight:900;margin:0;letter-spacing:-.3px}
.rating{display:inline-flex;align-items:center;gap:6px;font-weight:800;font-size:13px;color:#1f7a3c}
.meta{color:var(--muted);font-size:13px;line-height:1.5}
.card-foot{margin-top:auto;padding:12px 16px 16px;border-top:1px dashed var(--line);display:flex;align-items:center;justify-content:space-between;font-size:13px;font-weight:700;color:var(--muted)}
.pager{display:flex;align-items:center;justify-content:center;gap:8px;flex-wrap:wrap;padding:34px 0 10px}
.pager a,.pager span{min-width:42px;height:42px;display:grid;place-items:center;border-radius:12px;border:1px solid var(--line);font-weight:800;font-size:14px;padding:0 12px;background:#fff}
.pager a:hover{border-color:var(--brand);color:var(--brand)}
.pager .cur{background:var(--brand);border-color:var(--brand);color:#fff}
.pager .off{opacity:.4;pointer-events:none}
.count{text-align:center;color:var(--muted);font-size:13px;padding-bottom:26px}
.empty{padding:60px 0;text-align:center;color:var(--muted)}
.flash{position:fixed;left:50%;top:18px;transform:translateX(-50%);z-index:99;background:#128a3f;color:#fff;padding:12px 22px;border-radius:12px;font-weight:800;box-shadow:0 10px 26px rgba(2,6,12,.2)}
footer{padding:34px 0;color:var(--muted);font-size:13px}
@media(max-width:860px){.nav-links{display:none}.nav-in{height:66px;gap:12px}.toggle{display:none}}
</style>
</head>
<body>

<% if (flash != null) { %>
  <div class="flash" id="flash"><i class="fa-solid fa-circle-check"></i> <%= esc(flash) %></div>
<% } %>

<header class="nav">
  <div class="wrap nav-in">
    <a class="logo" href="<%= ctx %>/restaurants"><i class="fa-solid fa-bolt"></i> SwiftByte</a>

    <form class="nav-form" method="get" action="<%= ctx %>/restaurants">
      <div class="nav-search">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="q" value="<%= esc(q) %>" placeholder="Search restaurants, cuisines or areas">
      </div>
      <% if (!cuisine.trim().isEmpty()) { %>
        <input type="hidden" name="cuisine" value="<%= esc(cuisine) %>">
      <% } %>
      <% if (pageSize != 8) { %>
        <input type="hidden" name="size" value="<%= pageSize %>">
      <% } %>
      <label class="toggle">
        <input type="checkbox" name="openOnly" value="1" <%= onlyOpen ? "checked" : "" %>
               onchange="this.form.submit()"> Open now
      </label>
      <button class="btn-primary" type="submit">Search</button>
    </form>

    <nav class="nav-links">
      <a href="<%= ctx %>/cart"><i class="fa-solid fa-cart-shopping"></i> Cart</a>
      <a href="<%= ctx %>/orders">My Orders</a>
      <% if (loggedIn) { %>
        <a href="<%= ctx %>/profile">Profile</a>
        <a href="<%= ctx %>/logout">Logout</a>
      <% } else { %>
        <a href="<%= ctx %>/login.jsp">Sign in</a>
      <% } %>
    </nav>
  </div>
</header>

<section class="section">
  <div class="wrap">
    <h2>What’s on your mind?</h2>
    <div class="strip">
      <% for (Map.Entry<String,String> e : cuisines.entrySet()) {
           String cName = e.getKey();
           boolean active = cName.equalsIgnoreCase(cuisine.trim());
           String href = ctx + "/restaurants?cuisine="
                   + URLEncoder.encode(cName, StandardCharsets.UTF_8.name())
                   + (q.trim().isEmpty() ? "" : "&q=" + URLEncoder.encode(q.trim(), StandardCharsets.UTF_8.name()))
                   + (onlyOpen ? "&openOnly=1" : "");
      %>
        <a class="cuisine <%= active ? "active" : "" %>" href="<%= href %>">
          <span class="cuisine-circle">
            <img src="<%= e.getValue() %>" alt="<%= esc(cName) %>" loading="lazy" decoding="async">
          </span>
          <span class="cuisine-label"><%= esc(cName) %></span>
        </a>
      <% } %>
    </div>

    <% if (!cuisine.trim().isEmpty() || !q.trim().isEmpty() || onlyOpen) { %>
      <a class="chip-clear" href="<%= ctx %>/restaurants">
        <i class="fa-solid fa-xmark"></i> Clear filters
      </a>
    <% } %>
  </div>
</section>

<section class="section">
  <div class="wrap">
    <h2 id="restaurantsHeading">
      <%= cuisine.trim().isEmpty() ? "Top restaurant chains" : esc(cuisine) + " restaurants" %>
      <span class="meta">(<%= total %>)</span>
    </h2>

    <% if (pageItems.isEmpty()) { %>
      <div class="empty">
        <i class="fa-solid fa-utensils" style="font-size:32px"></i>
        <p>No restaurants match these filters. Try clearing them.</p>
      </div>
    <% } else { %>
      <div class="grid">
      <% for (Restaurant r : pageItems) {
           String img = (r.getImageUrl() == null || r.getImageUrl().trim().isEmpty())
                        ? fallbackImg : r.getImageUrl().trim();
           String menuUrl = ctx + "/menu?restaurantId=" + r.getRestaurantId();
           boolean open = isOpenNow(r);
      %>
        <article class="card">
          <div class="card-media">
            <a href="<%= menuUrl %>">
              <img src="<%= esc(img) %>" alt="<%= esc(r.getRestaurantName()) %>" loading="lazy" decoding="async">
            </a>
            <span class="badge <%= open ? "" : "closed" %>"><%= open ? "OPEN NOW" : "CLOSED" %></span>

            <form class="add-form" method="get" action="<%= ctx %>/menu">
              <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
              <input type="hidden" name="quickAdd" value="1">
              <button class="add-btn" type="submit"><i class="fa-solid fa-plus"></i> ADD TO CART</button>
            </form>
          </div>

          <div class="card-body">
            <a href="<%= menuUrl %>"><h3 class="card-title"><%= esc(r.getRestaurantName()) %></h3></a>
            <span class="rating">
  			<i class="fa-solid fa-star"></i>
  				<%= r.getRating() > 0 ? String.format("%.1f", r.getRating()) : "New" %>
			</span>
            
            <span class="meta"><%= esc(r.getCuisineType()) %></span>
            <span class="meta"><i class="fa-solid fa-location-dot"></i> <%= esc(r.getAddress()) %></span>
          </div>

          <div class="card-foot">
            <span><i class="fa-regular fa-clock"></i>
              <%= fmtTime(r.getOpeningTime()) %> – <%= fmtTime(r.getClosingTime()) %>
            </span>
            <a href="<%= menuUrl %>" style="color:var(--brand)">View menu <i class="fa-solid fa-arrow-right"></i></a>
          </div>
        </article>
      <% } %>
      </div>

      <%
        int win = 2;
        int start = Math.max(1, pageNo - win);
        int end   = Math.min(totalPages, pageNo + win);
      %>
      <nav class="pager">
        <a class="<%= pageNo <= 1 ? "off" : "" %>"
           href="<%= ctx %>/restaurants?page=<%= pageNo - 1 %><%= filtersQs %>#restaurantsHeading">
           <i class="fa-solid fa-chevron-left"></i>
        </a>

        <% if (start > 1) { %>
          <a href="<%= ctx %>/restaurants?page=1<%= filtersQs %>#restaurantsHeading">1</a>
          <% if (start > 2) { %><span class="off">…</span><% } %>
        <% } %>

        <% for (int p = start; p <= end; p++) {
             if (p == pageNo) { %>
               <span class="cur"><%= p %></span>
        <%   } else { %>
               <a href="<%= ctx %>/restaurants?page=<%= p %><%= filtersQs %>#restaurantsHeading"><%= p %></a>
        <%   }
           } %>

        <% if (end < totalPages) { %>
          <% if (end < totalPages - 1) { %><span class="off">…</span><% } %>
          <a href="<%= ctx %>/restaurants?page=<%= totalPages %><%= filtersQs %>#restaurantsHeading"><%= totalPages %></a>
        <% } %>

        <a class="<%= pageNo >= totalPages ? "off" : "" %>"
           href="<%= ctx %>/restaurants?page=<%= pageNo + 1 %><%= filtersQs %>#restaurantsHeading">
           <i class="fa-solid fa-chevron-right"></i>
        </a>
      </nav>

      <div class="count">
        Showing <%= (fromIndex + 1) %>–<%= toIndex %> of <%= total %> restaurants
        ·
        <a style="color:var(--brand)" href="<%= ctx %>/restaurants?page=1<%=
              (q.trim().isEmpty() ? "" : "&q=" + URLEncoder.encode(q.trim(), StandardCharsets.UTF_8.name()))
            + (cuisine.trim().isEmpty() ? "" : "&cuisine=" + URLEncoder.encode(cuisine.trim(), StandardCharsets.UTF_8.name()))
            + (onlyOpen ? "&openOnly=1" : "")
            + "&size=" + (pageSize == 8 ? 16 : 8) %>#restaurantsHeading">
           Show <%= (pageSize == 8 ? 16 : 8) %> per page
        </a>
      </div>
    <% } %>
  </div>
</section>

<footer class="wrap">
  SwiftByte — restaurant discovery connected to your live menu, cart and order flow.
</footer>

<script>
  var f = document.getElementById('flash');
  if (f) setTimeout(function(){ f.style.opacity = '0'; }, 3000);
</script>
</body>
</html>
