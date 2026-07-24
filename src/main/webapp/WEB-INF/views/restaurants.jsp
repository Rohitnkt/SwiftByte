<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.swiftbyte.model.Restaurant" %>
<%@ page import="com.swiftbyte.util.JspUtil" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    if (restaurants == null) {
        restaurants = Collections.emptyList();
    }

    List<Restaurant> topChains = (List<Restaurant>) request.getAttribute("topChains");
    if (topChains == null) {
        topChains = Collections.emptyList();
    }

    List<String> cuisineOptions = (List<String>) request.getAttribute("cuisineOptions");
    if (cuisineOptions == null) {
        cuisineOptions = Collections.emptyList();
    }

    String searchQuery = JspUtil.defaultIfBlank((String) request.getAttribute("searchQuery"), "");
    String selectedCuisine = JspUtil.defaultIfBlank((String) request.getAttribute("selectedCuisine"), "");
    int restaurantCount = request.getAttribute("restaurantCount") == null ? restaurants.size() : (Integer) request.getAttribute("restaurantCount");
    int totalRestaurantCount = request.getAttribute("totalRestaurantCount") == null ? restaurants.size() : (Integer) request.getAttribute("totalRestaurantCount");
    int offerCount = request.getAttribute("offerCount") == null ? 0 : (Integer) request.getAttribute("offerCount");
    int fastDeliveryCount = request.getAttribute("fastDeliveryCount") == null ? 0 : (Integer) request.getAttribute("fastDeliveryCount");
    String contextPath = request.getContextPath();
%>
<%! 
    private String locationFor(Restaurant restaurant) {
        if (JspUtil.hasText(restaurant.getLocation())) {
            return restaurant.getLocation();
        }
        if (JspUtil.hasText(restaurant.getAddress())) {
            return restaurant.getAddress();
        }
        return "Serving nearby hungry customers";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SwiftByte restaurant discovery experience with responsive restaurant cards, cuisine filters, offers, and quick access to each menu.">
    <title>SwiftByte | Restaurants Near You</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Sora:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/swiftbyte-ui.css">
</head>
<body>
    <header class="sb-topbar">
        <div class="sb-shell sb-topbar__inner">
            <a href="<%= contextPath %>/" class="sb-brand">
                <span class="sb-brand__mark">SB</span>
                <span class="sb-brand__copy">
                    <span class="sb-brand__title">SwiftByte</span>
                    <span class="sb-brand__caption">Restaurant discovery</span>
                </span>
            </a>

            <nav class="sb-nav" aria-label="Primary">
                <a class="sb-nav__link" href="<%= contextPath %>/">Home</a>
                <a class="sb-nav__link" href="#restaurants-grid">Restaurants</a>
                <a class="sb-nav__link" href="#offers">Offers</a>
                <a class="sb-nav__link" href="#delivery-promise">Delivery Promise</a>
                <a class="sb-button" href="#top-picks">Top picks</a>
            </nav>
        </div>
    </header>

    <main class="sb-main">
        <div class="sb-shell">
            <section class="sb-hero">
                <div class="sb-panel">
                    <div class="sb-hero__grid">
                        <div>
                            <span class="sb-eyebrow">Modern SwiftByte frontend</span>
                            <h1 class="sb-title">Discover restaurants and jump into a Swiggy-style menu flow.</h1>
                            <p class="sb-copy">
                                This page reads your restaurant backend and turns it into a responsive browsing experience
                                with search, cuisine chips, promo visibility, delivery timing, and fast access to each kitchen menu.
                            </p>

                            <form class="sb-search" action="<%= contextPath %>/restaurants" method="get">
                                <input
                                    class="sb-search__field"
                                    type="search"
                                    name="q"
                                    value="<%= JspUtil.escapeHtml(searchQuery) %>"
                                    placeholder="Search by restaurant, cuisine, locality, or offer">
                                <% if (JspUtil.hasText(selectedCuisine)) { %>
                                    <input type="hidden" name="cuisine" value="<%= JspUtil.escapeHtml(selectedCuisine) %>">
                                <% } %>
                                <button class="sb-button sb-search__submit" type="submit">Search restaurants</button>
                            </form>

                            <div class="sb-chip-row" id="cuisine-strip">
                                <a class="sb-chip <%= !JspUtil.hasText(selectedCuisine) ? "is-active" : "" %>" href="<%= contextPath %>/restaurants<%= JspUtil.hasText(searchQuery) ? "?q=" + URLEncoder.encode(searchQuery, StandardCharsets.UTF_8) : "" %>">
                                    All cuisines
                                </a>
                                <% for (String cuisine : cuisineOptions) {
                                       String cuisineHref = contextPath + "/restaurants?cuisine=" + URLEncoder.encode(cuisine, StandardCharsets.UTF_8);
                                       if (JspUtil.hasText(searchQuery)) {
                                           cuisineHref += "&q=" + URLEncoder.encode(searchQuery, StandardCharsets.UTF_8);
                                       }
                                %>
                                    <a class="sb-chip <%= cuisine.equalsIgnoreCase(selectedCuisine) ? "is-active" : "" %>" href="<%= cuisineHref %>">
                                        <%= JspUtil.escapeHtml(cuisine) %>
                                    </a>
                                <% } %>
                            </div>

                            <div class="sb-metrics">
                                <div class="sb-metric">
                                    <strong><%= restaurantCount %></strong>
                                    <span>Visible restaurants right now</span>
                                </div>
                                <div class="sb-metric">
                                    <strong><%= offerCount %></strong>
                                    <span>Kitchens showing live promo offers</span>
                                </div>
                                <div class="sb-metric">
                                    <strong><%= fastDeliveryCount %></strong>
                                    <span>Fast delivery kitchens under 25 minutes</span>
                                </div>
                            </div>
                        </div>

                        <aside class="sb-summary-card">
                            <span class="sb-summary-card__tag">SwiftByte highlights</span>
                            <h2 class="sb-summary-card__title">Built around the data you already have in `RestaurantDAO`.</h2>
                            <ul class="sb-list">
                                <li class="sb-list__item">
                                    <div>
                                        <strong><%= totalRestaurantCount %> active restaurants</strong>
                                        <span>Rendered from your backend model</span>
                                    </div>
                                    <span>Live</span>
                                </li>
                                <li class="sb-list__item">
                                    <div>
                                        <strong>Ratings, delivery, and promos</strong>
                                        <span>Shown directly on discovery cards</span>
                                    </div>
                                    <span>Responsive</span>
                                </li>
                                <li class="sb-list__item">
                                    <div>
                                        <strong>Menu screen per restaurant</strong>
                                        <span>Each card opens a Swiggy-inspired menu page</span>
                                    </div>
                                    <span>Connected</span>
                                </li>
                            </ul>
                        </aside>
                    </div>
                </div>
            </section>

            <section class="sb-section" id="offers">
                <div class="sb-section__head">
                    <div>
                        <span class="sb-section__eyebrow">Spotlight</span>
                        <h2 class="sb-section__title">Top chains and offer-led picks</h2>
                    </div>
                    <p class="sb-section__copy">
                        High-visibility cards give this the quick-scan feeling food delivery users expect on modern apps.
                    </p>
                </div>

                <% if (topChains.isEmpty()) { %>
                    <div class="sb-empty">
                        <strong>No featured chains yet</strong>
                        Add active restaurants in your database and this strip will fill automatically.
                    </div>
                <% } else { %>
                    <div class="sb-horizontal">
                        <% for (Restaurant restaurant : topChains) {
                               String imageUrl = JspUtil.resolveImageUrl(contextPath, restaurant.getImageUrl());
                        %>
                            <article class="sb-card sb-card--hover">
                                <div class="sb-media">
                                    <div class="sb-media__badge-row">
                                        <span class="sb-badge sb-badge--light"><%= JspUtil.formatRating(restaurant.getRating()) %> rating</span>
                                        <% if (JspUtil.hasText(restaurant.getPromoOffer())) { %>
                                            <span class="sb-badge sb-badge--dark"><%= JspUtil.escapeHtml(restaurant.getPromoOffer()) %></span>
                                        <% } else { %>
                                            <span class="sb-badge sb-badge--dark">Top chain</span>
                                        <% } %>
                                    </div>

                                    <% if (JspUtil.hasText(imageUrl)) { %>
                                        <img src="<%= imageUrl %>" alt="<%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %>" onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                        <div class="sb-media__fallback" style="display:none;">
                                            <strong><%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %></strong>
                                            <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Chef-driven menu")) %></span>
                                        </div>
                                    <% } else { %>
                                        <div class="sb-media__fallback">
                                            <strong><%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %></strong>
                                            <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Chef-driven menu")) %></span>
                                        </div>
                                    <% } %>
                                </div>

                                <div class="sb-card__body">
                                    <div class="sb-card__title-row">
                                        <div>
                                            <h3 class="sb-card__title"><%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %></h3>
                                            <div class="sb-card__subtle"><%= JspUtil.escapeHtml(locationFor(restaurant)) %></div>
                                        </div>
                                        <div class="sb-price"><%= JspUtil.escapeHtml(restaurant.getDeliveryTimeLabel()) %></div>
                                    </div>
                                    <div class="sb-meta">
                                        <span class="sb-meta__pill"><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Multi-cuisine")) %></span>
                                        <span class="sb-meta__pill"><%= restaurant.isTopChain() ? "Top chain" : "Independent kitchen" %></span>
                                    </div>
                                    <a class="sb-link" href="<%= contextPath %>/restaurant-menu?restaurantId=<%= restaurant.getRestaurantId() %>">Open menu</a>
                                </div>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>

            <section class="sb-section" id="top-picks">
                <div class="sb-section__head">
                    <div>
                        <span class="sb-section__eyebrow">Browse</span>
                        <h2 class="sb-section__title">Restaurant cards tuned for fast decisions</h2>
                    </div>
                    <p class="sb-section__copy">
                        Delivery time, cuisine, address, promo, and rating stay visible without crowding the card.
                    </p>
                </div>

                <div class="sb-grid sb-grid--two" id="delivery-promise">
                    <article class="sb-card sb-card--padded">
                        <h3 class="sb-card__title">Delivery-first browsing</h3>
                        <p class="sb-card__subtle">
                            The card system keeps the same mental model users expect from apps like Swiggy:
                            image first, offer second, then speed and confidence cues.
                        </p>
                    </article>
                    <article class="sb-card sb-card--padded">
                        <h3 class="sb-card__title">Backend-aware layout</h3>
                        <p class="sb-card__subtle">
                            Your `rating`, `promoOffer`, `location`, `deliveryTimeMin`, `deliveryTimeMax`, and `imageUrl`
                            fields are all surfaced directly in the UI.
                        </p>
                    </article>
                </div>
            </section>

            <section class="sb-section" id="restaurants-grid">
                <div class="sb-section__head">
                    <div>
                        <span class="sb-section__eyebrow">Restaurants</span>
                        <h2 class="sb-section__title">Menus one tap away</h2>
                    </div>
                    <p class="sb-section__copy">
                        <% if (JspUtil.hasText(searchQuery) || JspUtil.hasText(selectedCuisine)) { %>
                            Showing <%= restaurantCount %> filtered results for your current search and cuisine selection.
                        <% } else { %>
                            Explore the full active catalog and open any restaurant into its dedicated menu view.
                        <% } %>
                    </p>
                </div>

                <% if (restaurants.isEmpty()) { %>
                    <div class="sb-empty">
                        <strong>No restaurants match the current filters</strong>
                        Try another cuisine, clear the search, or add active restaurant rows in MySQL to populate the catalog.
                    </div>
                <% } else { %>
                    <div class="sb-grid sb-grid--cards">
                        <% for (Restaurant restaurant : restaurants) {
                               String imageUrl = JspUtil.resolveImageUrl(contextPath, restaurant.getImageUrl());
                        %>
                            <article class="sb-card sb-card--hover">
                                <div class="sb-media">
                                    <div class="sb-media__badge-row">
                                        <span class="sb-badge sb-badge--light"><%= JspUtil.formatRating(restaurant.getRating()) %> rating</span>
                                        <% if (JspUtil.hasText(restaurant.getPromoOffer())) { %>
                                            <span class="sb-badge sb-badge--dark"><%= JspUtil.escapeHtml(restaurant.getPromoOffer()) %></span>
                                        <% } else if (restaurant.isTopChain()) { %>
                                            <span class="sb-badge sb-badge--dark">Top chain</span>
                                        <% } %>
                                    </div>

                                    <% if (JspUtil.hasText(imageUrl)) { %>
                                        <img src="<%= imageUrl %>" alt="<%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %>" onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                        <div class="sb-media__fallback" style="display:none;">
                                            <strong><%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %></strong>
                                            <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Fresh kitchen menu")) %></span>
                                        </div>
                                    <% } else { %>
                                        <div class="sb-media__fallback">
                                            <strong><%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %></strong>
                                            <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Fresh kitchen menu")) %></span>
                                        </div>
                                    <% } %>
                                </div>

                                <div class="sb-card__body">
                                    <div class="sb-card__title-row">
                                        <div>
                                            <h3 class="sb-card__title"><%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %></h3>
                                            <div class="sb-card__subtle"><%= JspUtil.escapeHtml(locationFor(restaurant)) %></div>
                                        </div>
                                        <div class="sb-price"><%= JspUtil.escapeHtml(restaurant.getDeliveryTimeLabel()) %></div>
                                    </div>

                                    <div class="sb-meta">
                                        <span class="sb-meta__pill"><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Multi-cuisine")) %></span>
                                        <span class="sb-meta__pill"><%= restaurant.isActive() ? "Open now" : "Offline" %></span>
                                        <span class="sb-meta__pill"><%= restaurant.isTopChain() ? "Top chain" : "Curated kitchen" %></span>
                                    </div>

                                    <div class="sb-card__subtle">
                                        <%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getAddress(), "Address will appear here once added in the backend.")) %>
                                    </div>

                                    <div class="sb-card__title-row">
                                        <div class="sb-card__subtle">Phone: <%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getPhoneNumber(), "Contact info pending")) %></div>
                                        <a class="sb-link" href="<%= contextPath %>/restaurant-menu?restaurantId=<%= restaurant.getRestaurantId() %>">View menu</a>
                                    </div>
                                </div>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>
        </div>
    </main>

    <footer class="sb-footer">
        <div class="sb-shell">
            SwiftByte UI routed through your existing Java webapp. Restaurant discovery is now connected to the menu experience.
        </div>
    </footer>
</body>
</html>
