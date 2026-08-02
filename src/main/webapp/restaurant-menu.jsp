<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.swiftbyte.model.Menu" %>
<%@ page import="com.swiftbyte.model.Restaurant" %>
<%@ page import="com.swiftbyte.util.JspUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");

    List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
    if (menuItems == null) {
        menuItems = Collections.emptyList();
    }

    Map<String, List<Menu>> groupedMenu = (Map<String, List<Menu>>) request.getAttribute("groupedMenu");
    if (groupedMenu == null) {
        groupedMenu = new LinkedHashMap<>();
    }

    List<String> menuCategories = (List<String>) request.getAttribute("menuCategories");
    if (menuCategories == null) {
        menuCategories = new ArrayList<>();
    }

    List<Menu> recommendedItems = (List<Menu>) request.getAttribute("recommendedItems");
    if (recommendedItems == null) {
        recommendedItems = Collections.emptyList();
    }

    List<Restaurant> nearbyRestaurants = (List<Restaurant>) request.getAttribute("nearbyRestaurants");
    if (nearbyRestaurants == null) {
        nearbyRestaurants = Collections.emptyList();
    }

    int availableCount = request.getAttribute("availableCount") == null ? 0 : (Integer) request.getAttribute("availableCount");
    double startingPrice = request.getAttribute("startingPrice") == null ? 0 : (Double) request.getAttribute("startingPrice");
    String contextPath = request.getContextPath();
%>
<%! 
    private String restaurantLocation(Restaurant restaurant) {
        if (restaurant == null) {
            return "Restaurant unavailable";
        }
        if (JspUtil.hasText(restaurant.getLocation())) {
            return restaurant.getLocation();
        }
        if (JspUtil.hasText(restaurant.getAddress())) {
            return restaurant.getAddress();
        }
        return "Serving nearby customers";
    }

    private String hoursLabel(Restaurant restaurant) {
        if (restaurant == null) {
            return "Hours unavailable";
        }
        if (restaurant.getOpeningTime() == null && restaurant.getClosingTime() == null) {
            return "Flexible hours";
        }
        if (restaurant.getOpeningTime() == null) {
            return JspUtil.formatTime(restaurant.getClosingTime());
        }
        if (restaurant.getClosingTime() == null) {
            return JspUtil.formatTime(restaurant.getOpeningTime());
        }
        return JspUtil.formatTime(restaurant.getOpeningTime()) + " - " + JspUtil.formatTime(restaurant.getClosingTime());
    }

    private String safeDescription(Menu menuItem) {
        if (menuItem == null || !JspUtil.hasText(menuItem.getDescription())) {
            return "Freshly prepared and ready for quick ordering.";
        }
        return menuItem.getDescription();
    }

    private String searchableText(Menu menuItem) {
        if (menuItem == null) {
            return "";
        }
        String raw = JspUtil.defaultIfBlank(menuItem.getItemName(), "") + " " +
                JspUtil.defaultIfBlank(menuItem.getDescription(), "") + " " +
                JspUtil.defaultIfBlank(menuItem.getCategory(), "");
        return raw.toLowerCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SwiftByte restaurant menu screen styled for responsive browsing with category sections, recommendations, and menu item details.">
    <title>SwiftByte | <%= restaurant != null ? JspUtil.escapeHtml(restaurant.getRestaurantName()) : "Restaurant Menu" %></title>
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
                    <span class="sb-brand__caption">Restaurant menu</span>
                </span>
            </a>

            <nav class="sb-nav" aria-label="Secondary">
                <a class="sb-nav__link" href="<%= contextPath %>/">Home</a>
                <a class="sb-nav__link" href="<%= contextPath %>/restaurants">Browse restaurants</a>
                <% if (restaurant != null) { %>
                    <a class="sb-button" href="#menu-sections">Menu sections</a>
                <% } %>
            </nav>
        </div>
    </header>

    <main class="sb-main">
        <div class="sb-shell">
            <% if (restaurant == null) { %>
                <section class="sb-hero">
                    <div class="sb-panel">
                        <div class="sb-hero__grid">
                            <div>
                                <span class="sb-eyebrow">Menu not found</span>
                                <h1 class="sb-title">This restaurant could not be loaded from the backend.</h1>
                                <p class="sb-copy">
                                    The `restaurantId` may be missing, invalid, or not available in the current database.
                                    You can still jump back into the discovery screen and open another restaurant.
                                </p>
                                <div class="sb-chip-row">
                                    <a class="sb-button" href="<%= contextPath %>/restaurants">Back to restaurants</a>
                                    <a class="sb-button--ghost" href="<%= contextPath %>/">Return home</a>
                                </div>
                            </div>
                            <aside class="sb-summary-card">
                                <span class="sb-summary-card__tag">Recovery path</span>
                                <h2 class="sb-summary-card__title">The rest of the frontend is ready. We just need a valid restaurant row.</h2>
                                <ul class="sb-list">
                                    <li class="sb-list__item">
                                        <div>
                                            <strong>Check the URL</strong>
                                            <span>Example: `/restaurant-menu?restaurantId=1`</span>
                                        </div>
                                        <span>1</span>
                                    </li>
                                    <li class="sb-list__item">
                                        <div>
                                            <strong>Confirm the restaurant exists</strong>
                                            <span>The page reads from `RestaurantDAO#getRestaurantById`</span>
                                        </div>
                                        <span>2</span>
                                    </li>
                                </ul>
                            </aside>
                        </div>
                    </div>
                </section>

                <section class="sb-section">
                    <div class="sb-section__head">
                        <div>
                            <span class="sb-section__eyebrow">Nearby options</span>
                            <h2 class="sb-section__title">Try another kitchen</h2>
                        </div>
                    </div>

                    <% if (nearbyRestaurants.isEmpty()) { %>
                        <div class="sb-empty">
                            <strong>No nearby restaurant suggestions yet</strong>
                            Populate your database with active restaurants to preview this view fully.
                        </div>
                    <% } else { %>
                        <div class="sb-grid sb-grid--cards">
                            <% for (Restaurant nearby : nearbyRestaurants) {
                                   String imageUrl = JspUtil.resolveImageUrl(contextPath, nearby.getImageUrl());
                            %>
                                <article class="sb-card sb-card--hover">
                                    <div class="sb-media">
                                        <% if (JspUtil.hasText(imageUrl)) { %>
                                            <img src="<%= imageUrl %>" alt="<%= JspUtil.escapeHtml(nearby.getRestaurantName()) %>" onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                            <div class="sb-media__fallback" style="display:none;">
                                                <strong><%= JspUtil.escapeHtml(nearby.getRestaurantName()) %></strong>
                                                <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(nearby.getCuisineType(), "Fresh menu")) %></span>
                                            </div>
                                        <% } else { %>
                                            <div class="sb-media__fallback">
                                                <strong><%= JspUtil.escapeHtml(nearby.getRestaurantName()) %></strong>
                                                <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(nearby.getCuisineType(), "Fresh menu")) %></span>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="sb-card__body">
                                        <h3 class="sb-card__title"><%= JspUtil.escapeHtml(nearby.getRestaurantName()) %></h3>
                                        <div class="sb-card__subtle"><%= JspUtil.escapeHtml(restaurantLocation(nearby)) %></div>
                                        <div class="sb-meta">
                                            <span class="sb-meta__pill"><%= JspUtil.formatRating(nearby.getRating()) %> rating</span>
                                            <span class="sb-meta__pill"><%= JspUtil.escapeHtml(nearby.getDeliveryTimeLabel()) %></span>
                                        </div>
                                        <a class="sb-link" href="<%= contextPath %>/restaurant-menu?restaurantId=<%= nearby.getRestaurantId() %>">Open this menu</a>
                                    </div>
                                </article>
                            <% } %>
                        </div>
                    <% } %>
                </section>
            <% } else { %>
                <section class="sb-hero">
                    <div class="sb-panel">
                        <div class="sb-hero__grid">
                            <div>
                                <span class="sb-eyebrow">Swiggy-style menu view</span>
                                <h1 class="sb-title"><%= JspUtil.escapeHtml(restaurant.getRestaurantName()) %></h1>
                                <p class="sb-copy">
                                    <%= JspUtil.escapeHtml(restaurantLocation(restaurant)) %>. This screen reads the menu items from your backend
                                    and groups them into quick-scan sections with recommendations, availability cues, and a responsive ordering layout.
                                </p>

                                <div class="sb-chip-row">
                                    <span class="sb-chip is-active"><%= JspUtil.formatRating(restaurant.getRating()) %> rating</span>
                                    <span class="sb-chip"><%= JspUtil.escapeHtml(restaurant.getDeliveryTimeLabel()) %></span>
                                    <span class="sb-chip"><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Multi-cuisine")) %></span>
                                    <span class="sb-chip"><%= hoursLabel(restaurant) %></span>
                                </div>

                                <div class="sb-metrics">
                                    <div class="sb-metric">
                                        <strong><%= menuItems.size() %></strong>
                                        <span>Total menu items loaded</span>
                                    </div>
                                    <div class="sb-metric">
                                        <strong><%= availableCount %></strong>
                                        <span>Currently available items</span>
                                    </div>
                                    <div class="sb-metric">
                                        <strong><%= startingPrice > 0 ? JspUtil.escapeHtml(JspUtil.formatCurrency(startingPrice)) : "Soon" %></strong>
                                        <span>Starting price for live items</span>
                                    </div>
                                </div>
                            </div>

                            <aside class="sb-summary-card">
                                <span class="sb-summary-card__tag">Kitchen summary</span>
                                <h2 class="sb-summary-card__title">A menu flow designed for fast ordering confidence.</h2>
                                <ul class="sb-list">
                                    <li class="sb-list__item">
                                        <div>
                                            <strong>Promo</strong>
                                            <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getPromoOffer(), "No promo added yet")) %></span>
                                        </div>
                                        <span>Offer</span>
                                    </li>
                                    <li class="sb-list__item">
                                        <div>
                                            <strong>Hours</strong>
                                            <span><%= hoursLabel(restaurant) %></span>
                                        </div>
                                        <span>Open</span>
                                    </li>
                                    <li class="sb-list__item">
                                        <div>
                                            <strong>Kitchen type</strong>
                                            <span><%= restaurant.isTopChain() ? "Top chain format" : "Independent kitchen format" %></span>
                                        </div>
                                        <span>Style</span>
                                    </li>
                                </ul>
                            </aside>
                        </div>
                    </div>
                </section>

                <% if (!recommendedItems.isEmpty()) { %>
                    <section class="sb-section">
                        <div class="sb-section__head">
                            <div>
                                <span class="sb-section__eyebrow">Recommended</span>
                                <h2 class="sb-section__title">Quick picks from this kitchen</h2>
                            </div>
                            <p class="sb-section__copy">
                                These cards give the menu page the high-priority recommendation shelf users expect on food delivery apps.
                            </p>
                        </div>

                        <div class="sb-grid sb-grid--cards">
                            <% for (Menu item : recommendedItems) {
                                   String imageUrl = JspUtil.resolveImageUrl(contextPath, item.getImageUrl());
                            %>
                                <article class="sb-card sb-card--hover">
                                    <div class="sb-media">
                                        <div class="sb-media__badge-row">
                                            <span class="sb-badge sb-badge--light"><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(item.getCategory(), "Popular")) %></span>
                                            <span class="sb-badge sb-badge--dark"><%= JspUtil.escapeHtml(JspUtil.formatCurrency(item.getPrice())) %></span>
                                        </div>
                                        <% if (JspUtil.hasText(imageUrl)) { %>
                                            <img src="<%= imageUrl %>" alt="<%= JspUtil.escapeHtml(item.getItemName()) %>" onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                            <div class="sb-media__fallback" style="display:none;">
                                                <strong><%= JspUtil.escapeHtml(item.getItemName()) %></strong>
                                                <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(item.getCategory(), "Chef special")) %></span>
                                            </div>
                                        <% } else { %>
                                            <div class="sb-media__fallback">
                                                <strong><%= JspUtil.escapeHtml(item.getItemName()) %></strong>
                                                <span><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(item.getCategory(), "Chef special")) %></span>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="sb-card__body">
                                        <div class="sb-card__title-row">
                                            <div>
                                                <h3 class="sb-card__title"><%= JspUtil.escapeHtml(item.getItemName()) %></h3>
                                                <div class="sb-card__subtle"><%= JspUtil.escapeHtml(safeDescription(item)) %></div>
                                            </div>
                                        </div>
                                        <div class="sb-meta">
                                            <span class="sb-meta__pill"><%= item.isAvailable() ? "Available now" : "Sold out" %></span>
                                            <span class="sb-meta__pill"><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(item.getCategory(), "Menu item")) %></span>
                                        </div>
                                    </div>
                                </article>
                            <% } %>
                        </div>
                    </section>
                <% } %>

                <section class="sb-section" id="menu-sections">
                    <div class="sb-section__head">
                        <div>
                            <span class="sb-section__eyebrow">Menu</span>
                            <h2 class="sb-section__title">Category-led browsing for quick selection</h2>
                        </div>
                        <p class="sb-section__copy">
                            Search across items, filter by availability or price, and jump between categories without losing context.
                        </p>
                    </div>

                    <div class="sb-filter-bar">
                        <input class="sb-filter-input" type="search" placeholder="Search inside this menu" data-menu-search>
                        <button type="button" class="sb-chip is-active" data-filter="all">All items</button>
                        <button type="button" class="sb-chip" data-filter="available">Available now</button>
                        <button type="button" class="sb-chip" data-filter="budget">Under 250</button>
                    </div>

                    <div class="sb-category-rail">
                        <% for (String category : menuCategories) { %>
                            <a class="sb-chip" href="#<%= JspUtil.slugify(category) %>"><%= JspUtil.escapeHtml(category) %></a>
                        <% } %>
                    </div>

                    <div class="sb-menu-layout">
                        <div>
                            <% if (groupedMenu.isEmpty()) { %>
                                <div class="sb-empty">
                                    <strong>No menu items available yet</strong>
                                    Add rows to `menu_items` for this restaurant and the grouped sections will appear here.
                                </div>
                            <% } else { %>
                                <% for (Map.Entry<String, List<Menu>> entry : groupedMenu.entrySet()) {
                                       String category = entry.getKey();
                                       List<Menu> categoryItems = entry.getValue();
                                %>
                                    <section class="sb-card sb-card--padded sb-menu-section" id="<%= JspUtil.slugify(category) %>" data-menu-section>
                                        <div class="sb-section__head">
                                            <div>
                                                <span class="sb-section__eyebrow"><%= JspUtil.escapeHtml(category) %></span>
                                                <h3 class="sb-card__title"><%= categoryItems.size() %> items in this section</h3>
                                            </div>
                                        </div>

                                        <% for (Menu item : categoryItems) {
                                               String imageUrl = JspUtil.resolveImageUrl(contextPath, item.getImageUrl());
                                        %>
                                            <article
                                                class="sb-menu-item"
                                                data-menu-item
                                                data-category="<%= JspUtil.slugify(category) %>"
                                                data-price="<%= item.getPrice() %>"
                                                data-available="<%= item.isAvailable() %>"
                                                data-search="<%= JspUtil.escapeHtml(searchableText(item)) %>">
                                                <div>
                                                    <div class="sb-card__title-row">
                                                        <div>
                                                            <h4 class="sb-card__title"><%= JspUtil.escapeHtml(item.getItemName()) %></h4>
                                                            <div class="sb-card__subtle"><%= JspUtil.escapeHtml(safeDescription(item)) %></div>
                                                        </div>
                                                    </div>
                                                    <div class="sb-meta" style="margin-top:0.8rem;">
                                                        <span class="sb-status <%= item.isAvailable() ? "sb-status--available" : "sb-status--offline" %>">
                                                            <%= item.isAvailable() ? "Available now" : "Unavailable" %>
                                                        </span>
                                                        <span class="sb-meta__pill"><%= JspUtil.escapeHtml(JspUtil.formatCurrency(item.getPrice())) %></span>
                                                        <span class="sb-meta__pill"><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(item.getCategory(), "Menu item")) %></span>
                                                    </div>
                                                </div>

                                                <div class="sb-menu-item__media">
                                                    <% if (JspUtil.hasText(imageUrl)) { %>
                                                        <img src="<%= imageUrl %>" alt="<%= JspUtil.escapeHtml(item.getItemName()) %>" onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                                        <div class="sb-menu-item__fallback" style="display:none;"><%= JspUtil.escapeHtml(item.getItemName()) %></div>
                                                    <% } else { %>
                                                        <div class="sb-menu-item__fallback"><%= JspUtil.escapeHtml(item.getItemName()) %></div>
                                                    <% } %>

                                                    <button
                                                        type="button"
                                                        class="sb-menu-item__button"
                                                        data-add-button
                                                        <%= item.isAvailable() ? "" : "disabled" %>>
                                                        <%= item.isAvailable() ? "Add +" : "Sold out" %>
                                                    </button>
                                                </div>
                                            </article>
                                        <% } %>
                                    </section>
                                <% } %>
                            <% } %>
                        </div>

                        <aside class="sb-sticky">
                            <div class="sb-card sb-card--padded">
                                <span class="sb-section__eyebrow">Delivery promise</span>
                                <h3 class="sb-card__title">Why this menu flow works</h3>
                                <p class="sb-card__subtle">
                                    Users can scan categories, see availability immediately, and commit faster because the price
                                    and add action stay visually tied to each item image.
                                </p>
                            </div>

                            <div class="sb-card sb-card--padded" style="margin-top:1rem;">
                                <span class="sb-section__eyebrow">Kitchen details</span>
                                <div class="sb-mini-list" style="margin-top:0.8rem;">
                                    <div class="sb-mini-card">
                                        <div class="sb-mini-card__thumb"></div>
                                        <div>
                                            <strong><%= JspUtil.escapeHtml(JspUtil.defaultIfBlank(restaurant.getCuisineType(), "Multi-cuisine")) %></strong>
                                            <div class="sb-card__subtle">Cuisine identity</div>
                                        </div>
                                    </div>
                                    <div class="sb-mini-card">
                                        <div class="sb-mini-card__thumb"></div>
                                        <div>
                                            <strong><%= JspUtil.escapeHtml(restaurant.getDeliveryTimeLabel()) %></strong>
                                            <div class="sb-card__subtle">Estimated delivery window</div>
                                        </div>
                                    </div>
                                    <div class="sb-mini-card">
                                        <div class="sb-mini-card__thumb"></div>
                                        <div>
                                            <strong><%= hoursLabel(restaurant) %></strong>
                                            <div class="sb-card__subtle">Serving schedule</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <% if (!nearbyRestaurants.isEmpty()) { %>
                                <div class="sb-card sb-card--padded" style="margin-top:1rem;">
                                    <span class="sb-section__eyebrow">Nearby kitchens</span>
                                    <div class="sb-mini-list" style="margin-top:0.8rem;">
                                        <% for (Restaurant nearby : nearbyRestaurants) { %>
                                            <a class="sb-mini-card" href="<%= contextPath %>/restaurant-menu?restaurantId=<%= nearby.getRestaurantId() %>">
                                                <div class="sb-mini-card__thumb">
                                                    <% String nearbyImage = JspUtil.resolveImageUrl(contextPath, nearby.getImageUrl()); %>
                                                    <% if (JspUtil.hasText(nearbyImage)) { %>
                                                        <img src="<%= nearbyImage %>" alt="<%= JspUtil.escapeHtml(nearby.getRestaurantName()) %>">
                                                    <% } %>
                                                </div>
                                                <div>
                                                    <strong><%= JspUtil.escapeHtml(nearby.getRestaurantName()) %></strong>
                                                    <div class="sb-card__subtle"><%= JspUtil.escapeHtml(nearby.getDeliveryTimeLabel()) %></div>
                                                </div>
                                            </a>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </aside>
                    </div>
                </section>
            <% } %>
        </div>
    </main>

    <footer class="sb-footer">
        <div class="sb-shell">
            SwiftByte menu UI powered by `RestaurantDAO` and `MenuDAO`, designed for responsive restaurant and menu browsing.
        </div>
    </footer>

    <% if (restaurant != null) { %>
        <script>
            (function () {
                var searchInput = document.querySelector('[data-menu-search]');
                var filterButtons = Array.prototype.slice.call(document.querySelectorAll('[data-filter]'));
                var menuItems = Array.prototype.slice.call(document.querySelectorAll('[data-menu-item]'));
                var menuSections = Array.prototype.slice.call(document.querySelectorAll('[data-menu-section]'));
                var activeFilter = 'all';

                function applyFilters() {
                    var query = searchInput.value.trim().toLowerCase();

                    menuItems.forEach(function (item) {
                        var searchable = item.getAttribute('data-search') || '';
                        var price = parseFloat(item.getAttribute('data-price') || '0');
                        var available = item.getAttribute('data-available') === 'true';

                        var matchesQuery = !query || searchable.indexOf(query) !== -1;
                        var matchesFilter = activeFilter === 'all'
                            || (activeFilter === 'available' && available)
                            || (activeFilter === 'budget' && price <= 250);

                        item.hidden = !(matchesQuery && matchesFilter);
                    });

                    menuSections.forEach(function (section) {
                        var visibleItems = section.querySelectorAll('[data-menu-item]:not([hidden])');
                        section.hidden = visibleItems.length === 0;
                    });
                }

                filterButtons.forEach(function (button) {
                    button.addEventListener('click', function () {
                        activeFilter = button.getAttribute('data-filter') || 'all';
                        filterButtons.forEach(function (otherButton) {
                            otherButton.classList.toggle('is-active', otherButton === button);
                        });
                        applyFilters();
                    });
                });

                searchInput.addEventListener('input', applyFilters);

                document.querySelectorAll('[data-add-button]').forEach(function (button) {
                    button.addEventListener('click', function () {
                        if (button.disabled) {
                            return;
                        }

                        var currentCount = parseInt(button.getAttribute('data-count') || '0', 10) + 1;
                        button.setAttribute('data-count', String(currentCount));
                        button.textContent = currentCount === 1 ? 'Added' : 'Added ' + currentCount;
                    });
                });

                applyFilters();
            })();
        </script>
    <% } %>
</body>
</html>
