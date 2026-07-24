<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.swiftbyte.model.Restaurant"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Restaurants | SwiftByte</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    background:#f5f5f5;
}

header{
    background:#ff5722;
    color:white;
    padding:20px;
    text-align:center;
}

.container{
    width:90%;
    margin:30px auto;

    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(320px,1fr));
    gap:25px;
}

.card{

    background:white;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 4px 10px rgba(0,0,0,0.1);

    transition:.3s;
}

.card:hover{

    transform:translateY(-6px);
}

.card img{

    width:100%;
    height:220px;
    object-fit:cover;
}

.card-body{

    padding:18px;
}

.card-body h2{

    color:#333;
    margin-bottom:10px;
}

.card-body p{

    color:#666;
    margin:6px 0;
}

.rating{

    color:#ff9800;
    font-weight:bold;
}

.btn{

    display:inline-block;
    margin-top:15px;

    background:#ff5722;
    color:white;
    text-decoration:none;

    padding:10px 18px;
    border-radius:6px;
}

.btn:hover{

    background:#e64a19;
}

</style>

</head>

<body>

<header>

<h1>🍽️ SwiftByte Restaurants</h1>

</header>

<div class="container">

<%

List<Restaurant> restaurants =
(List<Restaurant>)request.getAttribute("restaurants");

if(restaurants != null && !restaurants.isEmpty()){

for(Restaurant r : restaurants){

%>

<div class="card">

<img src="<%= r.getImageUrl() %>" alt="<%= r.getRestaurantName() %>">

<div class="card-body">

<h2><%= r.getRestaurantName() %></h2>

<p><strong>Cuisine:</strong> <%= r.getCuisineType() %></p>

<p><strong>Address:</strong> <%= r.getAddress() %></p>

<p><strong>Location:</strong> <%= r.getLocation() %></p>

<p class="rating">
⭐ <%= r.getRating() %>
</p>

<p>
<strong>Delivery Time:</strong>
<%= r.getDeliveryTimeLabel() %>
</p>

<p>
<strong>Offer:</strong>
<%= r.getPromoOffer() == null ? "No Offers" : r.getPromoOffer() %>
</p>

<p>
<strong>Status:</strong>
<%= r.isActive() ? "Open" : "Closed" %>
</p>

<p>
<strong>Top Chain:</strong>
<%= r.isTopChain() ? "Yes" : "No" %>
</p>

<a href="menu?restaurantId=<%=r.getRestaurantId()%>" class="btn">
View Menu
</a>

</div>

</div>

<%

}

}else{

%>

<h2 style="text-align:center;">No Restaurants Available</h2>

<%

}

%>

</div>

</body>
</html>