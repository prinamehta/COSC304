<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // Check if the user is authenticated
    Boolean isAuthenticated = (Boolean) session.getAttribute("isAuthenticated");

    if (isAuthenticated == null || !isAuthenticated) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get product ID from request
    int productId = Integer.parseInt(request.getParameter("id"));

    try {
        getConnection();
        String deleteSql = "DELETE FROM Product WHERE productId = ?";
        PreparedStatement deleteStmt = con.prepareStatement(deleteSql);
        deleteStmt.setInt(1, productId);
        int rowsAffected = deleteStmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<p>Product deleted successfully!</p>");
        } else {
            out.println("<p>Product not found.</p>");
        }
    } catch (SQLException ex) {
        out.println("Error: " + ex.getMessage());
    } finally {
        closeConnection();
    }
%>

<html>
<head>
    <title>Delete Product</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Delete Product</h2>
        <p>Are you sure you want to delete this product?</p>
        <form method="post">
            <button type="submit" class="btn btn-danger">Delete</button>
        </form>
        <a href="admin.jsp" class="btn btn-secondary">Cancel</a>
    </div>
</body>
</html>
