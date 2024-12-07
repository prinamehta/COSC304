<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<style>
  body {
    font-family: 'Arial', sans-serif;
    background-color: #f9f9f9;
    color: #333;
  }
  h3 {
    font-family: 'Georgia', serif;
    color: #007bff;
    margin-bottom: 20px;
  }
  .admin-section {
    margin-bottom: 40px;
  }
  .table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
  }
  .table th, .table td {
    padding: 10px;
    border: 1px solid #ddd;
    text-align: center;
  }
  .table th {
    background-color: #f2f2f2;
  }
  .btn {
    padding: 10px 15px;
    font-size: 14px;
    color: white;
    background-color: #007bff;
    border: none;
    border-radius: 5px;
  }
  .btn:hover {
    background-color: #0056b3;
  }
</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
  String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
  // Print out total order amount by day
  String sql = "SELECT year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

  NumberFormat currFormat = NumberFormat.getCurrencyInstance();

  try {  
    out.println("<h3>Administrator Sales Report by Day</h3>");
    getConnection();
    Statement stmt = con.createStatement(); 
    stmt.execute("USE orders");

    ResultSet rst = con.createStatement().executeQuery(sql);    
    out.println("<div class='admin-section'><h4>Sales Report</h4>");
    out.println("<table class='table'>");
    out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

    while (rst.next()) {
      out.println("<tr><td>" + rst.getString(1) + "-" + rst.getString(2) + "-" + rst.getString(3) + "</td><td>" + currFormat.format(rst.getDouble(4)) + "</td></tr>");
    }
    out.println("</table></div>");
  } catch (SQLException ex) {
    out.println(ex); 
  } finally {  
    closeConnection();  
  }
%>

<!-- List all customers -->
<%
  try {
    out.println("<div class='admin-section'><h4>List of Customers</h4>");
    String customerSql = "SELECT customerId, firstName, lastName, email FROM Customer";
    getConnection();
    ResultSet customerRst = con.createStatement().executeQuery(customerSql);
    out.println("<table class='table'>");
    out.println("<tr><th>Customer ID</th><th>First Name</th><th>Last Name</th><th>Email</th></tr>");

    while (customerRst.next()) {
      out.println("<tr><td>" + customerRst.getInt(1) + "</td><td>" + customerRst.getString(2) + "</td><td>" + customerRst.getString(3) + "</td><td>" + customerRst.getString(4) + "</td></tr>");
    }
    out.println("</table></div>");
  } catch (SQLException ex) {
    out.println(ex);
  } finally {
    closeConnection();
  }
%>

<!-- Add new product form -->
<%
  if ("POST".equals(request.getMethod())) {
    String prodName = request.getParameter("productName");
    String prodPrice = request.getParameter("productPrice");
    String prodCategory = request.getParameter("category");
    String prodImage = request.getParameter("productImage");

    try {
      String insertSql = "INSERT INTO Product (productName, productPrice, categoryId, productImageURL) VALUES (?, ?, ?, ?)";
      getConnection();
      PreparedStatement pstmt = con.prepareStatement(insertSql);
      pstmt.setString(1, prodName);
      pstmt.setDouble(2, Double.parseDouble(prodPrice));
      pstmt.setInt(3, Integer.parseInt(prodCategory));
      pstmt.setString(4, prodImage);
      pstmt.executeUpdate();
      out.println("<p>Product added successfully!</p>");
    } catch (SQLException ex) {
      out.println(ex);
    } finally {
      closeConnection();
    }
  }
%>

<div class="admin-section">
  <h4>Add New Product</h4>
  <form method="post" action="">
    <div class="form-group">
      <label for="productName">Product Name:</label>
      <input type="text" id="productName" name="productName" class="form-control" required><br>

      <label for="productPrice">Price:</label>
      <input type="text" id="productPrice" name="productPrice" class="form-control" required><br>

      <label for="category">Category ID:</label>
      <input type="text" id="category" name="category" class="form-control" required><br>

      <label for="productImage">Product Image URL:</label>
      <input type="text" id="productImage" name="productImage" class="form-control"><br>

      <button type="submit" class="btn">Add Product</button>
    </div>
  </form>
</div>

<!-- Update or Delete product -->
<%
  try {
    out.println("<div class='admin-section'><h4>Update or Delete Product</h4>");
    String productSql = "SELECT productId, productName, productPrice FROM Product";
    getConnection();
    ResultSet productRst = con.createStatement().executeQuery(productSql);
    out.println("<table class='table'>");
    out.println("<tr><th>Product ID</th><th>Product Name</th><th>Price</th><th>Actions</th></tr>");

    while (productRst.next()) {
      out.println("<tr>");
      out.println("<td>" + productRst.getInt(1) + "</td>");
      out.println("<td>" + productRst.getString(2) + "</td>");
      out.println("<td>" + currFormat.format(productRst.getDouble(3)) + "</td>");
      out.println("<td><a href='updateProduct.jsp?id=" + productRst.getInt(1) + "' class='btn'>Update</a> | ");
      out.println("<a href='deleteProduct.jsp?id=" + productRst.getInt(1) + "' class='btn'>Delete</a></td>");
      out.println("</tr>");
    }
    out.println("</table></div>");
  } catch (SQLException ex) {
    out.println(ex);
  } finally {
    closeConnection();
  }
%>

</body>
</html>
