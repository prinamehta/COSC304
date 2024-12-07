<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Cosmetics' Shop</title>
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
  .product-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
  }
  .product-card {
    display: flex;
    align-items: center;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 15px;
    width: 45%;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    background-color: #fff;
    gap: 15px;
  }
  .product-card img {
    max-width: 100px;
    max-height: 100px;
    object-fit: cover;
    border-radius: 5px;
  }
  .product-info {
    flex-grow: 1;
  }
  .product-card h4 {
    color: #ff5722;
    font-size: 18px;
    margin-bottom: 10px;
  }
  .product-card p {
    font-size: 14px;
    margin-bottom: 10px;
    color: #666;
  }
  .add-to-cart {
    display: inline-block;
    padding: 10px 15px;
    font-size: 14px;
    color: #fff;
    background-color: #007bff;
    text-decoration: none;
    border-radius: 5px;
  }
  .add-to-cart:hover {
    background-color: #0056b3;
  }
  .reviews-btn {
    display: inline-block;
    padding: 8px 12px;
    font-size: 14px;
    color: #fff;
    background-color: #FB7951;
    text-decoration: none;
    border-radius: 5px;
  }
  .reviews-btn:hover {
    background-color: #e64a19;
  }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
  <h2>Browse Products By Category and Search by Product Name:</h2>

  <form method="get" action="listprod.jsp">
    <div class="form-group">
      <label for="categoryName">Select Category:</label>
      <select size="1" name="categoryName" class="form-control" style="width: auto; display: inline-block;">
        <option>All</option>
        <option>Makeup</option>
        <option>Skincare</option>
        <option>Haircare</option>      
      </select>
      <input type="text" name="productName" size="50" class="form-control" placeholder="Search Product" style="width: 300px; display: inline-block;">
      <button type="submit" class="btn btn-primary">Submit</button>
      <button type="button" class="btn btn-secondary" onclick="window.location.href='listprod.jsp'">Reset</button>
    </div>
  </form>

  <%
  // Colors for different item categories
  HashMap<String, String> colors = new HashMap<String, String>();
  colors.put("Makeup", "#007bff");
  colors.put("Skincare", "#28a745");
  colors.put("Haircare", "#ff5722");
  %>

  <%
  String name = request.getParameter("productName");
  String category = request.getParameter("categoryName");

  boolean hasNameParam = name != null && !name.equals("");
  boolean hasCategoryParam = category != null && !category.equals("") && !category.equals("All");
  String filter = "", sql = "";

  if (hasNameParam && hasCategoryParam) {
    filter = "<h3>Products containing '" + name + "' in category: '" + category + "'</h3>";
    name = '%' + name + '%';
    sql = "SELECT productId, productName, productPrice, categoryName, productImageURL FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ? AND categoryName = ?";
  } else if (hasNameParam) {
    filter = "<h3>Products containing '" + name + "'</h3>";
    name = '%' + name + '%';
    sql = "SELECT productId, productName, productPrice, categoryName, productImageURL FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ?";
  } else if (hasCategoryParam) {
    filter = "<h3>Products in category: '" + category + "'</h3>";
    sql = "SELECT productId, productName, productPrice, categoryName, productImageURL FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE categoryName = ?";
  } else {
    filter = "<h3>All Products</h3>";
    sql = "SELECT productId, productName, productPrice, categoryName, productImageURL FROM Product P JOIN Category C ON P.categoryId = C.categoryId";
  }

  out.println(filter);

  NumberFormat currFormat = NumberFormat.getCurrencyInstance();

  try {
    getConnection();
    Statement stmt = con.createStatement();
    stmt.execute("USE orders");

    PreparedStatement pstmt = con.prepareStatement(sql);
    if (hasNameParam) {
      pstmt.setString(1, name);
      if (hasCategoryParam) {
        pstmt.setString(2, category);
      }
    } else if (hasCategoryParam) {
      pstmt.setString(1, category);
    }

    ResultSet rst = pstmt.executeQuery();
  %>

  <div class="product-grid">
    <%
    while (rst.next()) {
      int id = rst.getInt(1);
      String itemCategory = rst.getString(4);
      String color = colors.getOrDefault(itemCategory, "#333");
      String imageLoc = rst.getString(5);
    %>
    <div class="product-card">
      <% if (imageLoc != null && !imageLoc.isEmpty()) { %>
        <img src="<%= imageLoc %>" alt="<%= rst.getString(2) %>">
      <% } else { %>
        <img src="images/placeholder.jpg" alt="No Image Available">
      <% } %>
      <div class="product-info">
        <h4 style="color: <%= color %>;"><%= rst.getString(2) %></h4>
        <p>Category: <%= itemCategory %></p>
        <p>Price: <%= currFormat.format(rst.getDouble(3)) %></p>
        <a href="addcart.jsp?id=<%= id %>&name=<%= rst.getString(2) %>&price=<%= rst.getDouble(3) %>" class="add-to-cart">Add to Cart</a>
        <!-- Reviews Button -->
        <a href="reviews.jsp?id=<%= id %>" class="reviews-btn">View Reviews</a>
      </div>
    </div>
    <% } %>
  </div>

  <%
    closeConnection();
  } catch (SQLException ex) {
    out.println("<p>Error: " + ex.getMessage() + "</p>");
  }
  %>

</div>

</body>
</html>
