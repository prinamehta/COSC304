<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // Check if the user is authenticated
    Boolean isAuthenticated = (Boolean) session.getAttribute("isAuthenticated");

    if (isAuthenticated == null || !isAuthenticated) {
        response.sendRedirect("loginPage.jsp");
        return;
    }

    // Get product ID from request
    int productId = Integer.parseInt(request.getParameter("id"));

    // Fetch the product details from the database
    Product product = null;
    try {
        getConnection();
        String sql = "SELECT * FROM Product WHERE productId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, productId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            product = new Product(
                rs.getInt("productId"),
                rs.getString("productName"),
                rs.getDouble("productPrice"),
                rs.getInt("categoryId"),
                rs.getString("productImageURL")
            );
        }
    } catch (SQLException ex) {
        out.println("Error: " + ex.getMessage());
    } finally {
        closeConnection();
    }
%>

<html>
<head>
    <title>Update Product</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Update Product</h2>
        <form method="post" action="updateProduct.jsp?id=<%= productId %>">
            <div class="form-group">
                <label for="productName">Product Name:</label>
                <input type="text" class="form-control" id="productName" name="productName" value="<%= product.getProductName() %>" required>
            </div>
            <div class="form-group">
                <label for="productPrice">Price:</label>
                <input type="text" class="form-control" id="productPrice" name="productPrice" value="<%= product.getProductPrice() %>" required>
            </div>
            <div class="form-group">
                <label for="productImage">Product Image URL:</label>
                <input type="text" class="form-control" id="productImage" name="productImage" value="<%= product.getProductImageURL() %>" required>
            </div>
            <button type="submit" class="btn btn-primary">Update Product</button>
        </form>
    </div>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String updatedName = request.getParameter("productName");
            String updatedPrice = request.getParameter("productPrice");
            String updatedImage = request.getParameter("productImage");

            try {
                getConnection();
                String updateSql = "UPDATE Product SET productName = ?, productPrice = ?, productImageURL = ? WHERE productId = ?";
                PreparedStatement updateStmt = con.prepareStatement(updateSql);
                updateStmt.setString(1, updatedName);
                updateStmt.setDouble(2, Double.parseDouble(updatedPrice));
                updateStmt.setString(3, updatedImage);
                updateStmt.setInt(4, productId);
                updateStmt.executeUpdate();

                out.println("<p>Product updated successfully!</p>");
            } catch (SQLException ex) {
                out.println("Error: " + ex.getMessage());
            } finally {
                closeConnection();
            }
        }
    %>
</body>
</html>
