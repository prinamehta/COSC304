<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map,java.math.BigDecimal" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Glam & Glow Order Processing</title>
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f9f9f9;
      color: #333;
    }
    .container {
      margin-top: 30px;
    }
    h1 {
      color: #007bff;
      margin-bottom: 20px;
      text-align: center;
    }
    h2 a {
      color: #28a745;
      text-decoration: none;
    }
    h2 a:hover {
      color: #218838;
    }
    table {
      margin: 0 auto;
      width: 80%;
      border-collapse: collapse;
    }
    table th, table td {
      border: 1px solid #ddd;
      padding: 10px;
      text-align: center;
    }
    table th {
      background-color: #007bff;
      color: #fff;
    }
    table tr:nth-child(even) {
      background-color: #f2f2f2;
    }
    .btn {
      display: block;
      width: 200px;
      margin: 20px auto;
      padding: 10px;
      font-size: 16px;
      text-align: center;
      background-color: #007bff;
      color: white;
      border-radius: 5px;
      text-decoration: none;
    }
    .btn:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>

<div class="container">
<%
  String custId = request.getParameter("customerId");
  @SuppressWarnings({"unchecked"})
  HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

  if (custId == null || custId.equals("")) {
%>
  <h1>Invalid Customer ID</h1>
  <p class="text-center">Go back to the previous page and try again.</p>
  <a href="checkout.html" class="btn">Return to Checkout</a>
<%
  } else if (productList == null) {
%>
  <h1>Your Shopping Cart is Empty</h1>
  <a href="shop.html" class="btn">Return to Shop</a>
<%
  } else {
    int num = -1;
    try {
      num = Integer.parseInt(custId);
    } catch (Exception e) {
%>
  <h1>Invalid Customer ID</h1>
  <p class="text-center">Go back to the previous page and try again.</p>
  <a href="checkout.html" class="btn">Return to Checkout</a>
<%
      return;
    }

    String sql = "SELECT customerId, firstName + ' ' + lastName FROM Customer WHERE customerId = ?";
    NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

    try {
      getConnection();
      Statement stmt = con.createStatement();
      stmt.execute("USE orders");

      PreparedStatement pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, num);
      ResultSet rst = pstmt.executeQuery();
      int orderId = 0;
      String custName = "";

      if (!rst.next()) {
%>
  <h1>Invalid Customer ID</h1>
  <p class="text-center">Go back to the previous page and try again.</p>
  <a href="checkout.html" class="btn">Return to Checkout</a>
<%
      } else {
        custName = rst.getString(2);

        sql = "INSERT INTO OrderSummary (customerId, totalAmount, orderDate) VALUES(?, 0, ?)";
        pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setInt(1, num);
        pstmt.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
        pstmt.executeUpdate();
        ResultSet keys = pstmt.getGeneratedKeys();
        keys.next();
        orderId = keys.getInt(1);

%>
  <h1>Your Order Summary</h1>
  <table>
    <tr>
      <th>Product ID</th>
      <th>Product Name</th>
      <th>Quantity</th>
      <th>Price</th>
      <th>Subtotal</th>
    </tr>
<%
        double total = 0;
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();

        while (iterator.hasNext()) {
          Map.Entry<String, ArrayList<Object>> entry = iterator.next();
          ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
          String productId = (String) product.get(0);
          String productName = (String) product.get(1);
          String price = (String) product.get(2);
          double pr = Double.parseDouble(price);
          int qty = ((Integer) product.get(3)).intValue();
          total += pr * qty;

          sql = "INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES(?, ?, ?, ?)";
          pstmt = con.prepareStatement(sql);
          pstmt.setInt(1, orderId);
          pstmt.setInt(2, Integer.parseInt(productId));
          pstmt.setInt(3, qty);
          pstmt.setString(4, price);
          pstmt.executeUpdate();
%>
    <tr>
      <td><%= productId %></td>
      <td><%= productName %></td>
      <td><%= qty %></td>
      <td><%= currFormat.format(pr) %></td>
      <td><%= currFormat.format(pr * qty) %></td>
    </tr>
<%
        }

        out.println("<tr><td colspan='4' style='text-align:right'><b>Order Total</b></td>");
        out.println("<td><b>" + currFormat.format(total) + "</b></td></tr>");

        sql = "UPDATE OrderSummary SET totalAmount = ? WHERE orderId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setDouble(1, total);
        pstmt.setInt(2, orderId);
        pstmt.executeUpdate();
%>
  </table>
  <h1>Order Completed Successfully</h1>
  <p class="text-center">Your order reference number is: <b><%= orderId %></b></p>
  <p class="text-center">Shipping to customer ID: <b><%= custId %></b>, Name: <b><%= custName %></b></p>
  <a href="shop.html" class="btn">Return to Shop</a>
<%
        session.setAttribute("productList", null);
      }
    } catch (SQLException ex) {
      out.println("<p class='text-danger'>Error: " + ex.getMessage() + "</p>");
    } finally {
      closeConnection();
    }
  }
%>
</div>
</body>
</html>
