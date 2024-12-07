<!DOCTYPE html>
<html>
<head>
  <title>Glam & Glow Checkout</title>
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f9f9f9;
      color: #333;
    }
    .container {
      margin-top: 50px;
      text-align: center;
    }
    h1 {
      font-family: 'Georgia', serif;
      color: #007bff;
      margin-bottom: 30px;
    }
    form {
      display: inline-block;
      text-align: left;
      background-color: #fff;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    input[type="text"] {
      width: 100%;
      padding: 10px;
      margin-bottom: 20px;
      font-size: 16px;
      border: 1px solid #ddd;
      border-radius: 5px;
    }
    input[type="submit"],
    input[type="reset"] {
      padding: 10px 20px;
      font-size: 16px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
    input[type="submit"] {
      background-color: #28a745;
      color: white;
    }
    input[type="submit"]:hover {
      background-color: #218838;
    }
    input[type="reset"] {
      background-color: #ffc107;
      color: white;
    }
    input[type="reset"]:hover {
      background-color: #e0a800;
    }
  </style>
</head>
<body>

  <div class="container">
    <h1>Enter Customer ID</h1>
    <form method="POST" action="checkout.jsp">
      <label for="customerId">Customer ID:</label>
      <input type="text" id="customerId" name="customerId" required>
      <input type="submit" value="Submit">
    </form>
  </div>

  <%
    // Check if the form is submitted
    String customerId = request.getParameter("customerId");
    if (customerId != null && !customerId.isEmpty()) {
        // Assuming you process the customerId (e.g., save it in session)
        session.setAttribute("customerId", customerId);
        
        // Redirect back to the reviews page (retrieve the 'redirect' parameter)
        String redirectUrl = request.getParameter("redirect");
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("reviews.jsp");
        }
    }
  %>

</body>
</html>
