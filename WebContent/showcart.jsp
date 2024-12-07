<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Your Shopping Cart</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<style>
  body {
    font-family: 'Arial', sans-serif;
    background-color: #f9f9f9;
    color: #333;
  }
  h2 {
    font-family: 'Georgia', serif;
    color: #007bff;
    margin-bottom: 20px;
  }
  .cart-grid {
    display: flex;
    flex-direction: column;
    gap: 20px;
    align-items: center;
    margin-bottom: 20px;
  }
  .cart-card {
    display: flex;
    align-items: center;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 15px;
    width: 80%;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    background-color: #fff;
    gap: 15px;
  }
  .cart-card img {
    max-width: 100px;
    max-height: 100px;
    object-fit: cover;
    border-radius: 5px;
  }
  .cart-info {
    flex-grow: 1;
  }
  .cart-card h4 {
    color: #ff5722;
    font-size: 18px;
    margin-bottom: 10px;
  }
  .cart-card p {
    font-size: 14px;
    margin-bottom: 10px;
    color: #666;
  }
  .cart-actions {
    display: flex;
    gap: 15px;
    justify-content: center;
  }
  .checkout-button {
    padding: 10px 20px;
    font-size: 16px;
    color: #fff;
    background-color: #28a745;
    text-decoration: none;
    border-radius: 5px;
  }
  .checkout-button:hover {
    background-color: #218838;
  }
  .remove-button {
    padding: 8px 15px;
    font-size: 14px;
    color: #fff;
    background-color: #dc3545;
    text-decoration: none;
    border-radius: 5px;
  }
  .remove-button:hover {
    background-color: #c82333;
  }
  .quantity-controls {
    display: flex;
    align-items: center;
    gap: 10px;
  }
  .quantity-button {
    background-color: #007bff;
    color: white;
    padding: 3px 8px;
    border-radius: 5px;
    font-size: 14px; /* Smaller size */
    cursor: pointer;
  }
  .quantity-button:hover {
    background-color: #0056b3;
  }
  .continue-shopping-button {
    padding: 10px 20px;
    font-size: 16px;
    color: #fff;
    background-color: #17a2b8;
    text-decoration: none;
    border-radius: 5px;
  }
  .continue-shopping-button:hover {
    background-color: #138496;
  }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
  <h2>Your Shopping Cart</h2>

  <%
  // Get the current list of products from the session
  HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
  
  if (productList == null || productList.isEmpty()) {
  %>
    <p>Your cart is empty. Add some products!</p>
    <!-- Continue shopping button if the cart is empty -->
    <div class="cart-actions">
      <a href="listprod.jsp" class="continue-shopping-button">Continue Shopping</a>
    </div>
  <%
  } else {
    // Iterate through the cart items and display them
  %>
    <div class="cart-grid">
      <%
      for (String productId : productList.keySet()) {
          ArrayList<Object> product = productList.get(productId);
          String id = (String) product.get(0);
          String name = (String) product.get(1);
          String price = (String) product.get(2);
          Integer quantity = (Integer) product.get(3);
      %>
      <div class="cart-card">
        <img src="img/<%= productId %>.jpg" alt="<%= name %>">
        <div class="cart-info">
          <h4><%= name %></h4>
          <p>Price: <%= price %></p>
          <div class="quantity-controls">
            <form action="updateCart.jsp" method="POST">
              <input type="hidden" name="productId" value="<%= id %>">
              <button type="submit" name="action" value="decrease" class="quantity-button">-</button>
              <span><%= quantity %></span>
              <button type="submit" name="action" value="increase" class="quantity-button">+</button>
            </form>
          </div>
          <p>Total: <%= Double.parseDouble(price) * quantity %></p>
        </div>
        <div class="cart-actions">
          <a href="removeItem.jsp?id=<%= id %>" class="remove-button">Remove</a>
        </div>
      </div>
      
      <%
      }
      %>
    </div>
    <div class="cart-actions">
      <a href="checkout.jsp" class="checkout-button">Proceed to Checkout</a>
      <a href="listprod.jsp" class="continue-shopping-button">Continue Shopping</a>
    </div>
  <%
  }
  %>

</div>

</body>
</html>
