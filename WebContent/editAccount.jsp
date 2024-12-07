<%@ page import="java.sql., java.util.regex."%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Account - Glam & Glow</title>
</head>
<body>

<h2 align="center">Edit Your Account</h2>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
        response.sendRedirect("login.jsp");
    }

    // Fetch the user's current details
    String sql = "SELECT firstName, lastName, email, phonenum, address, city, state, postalCode, country, password FROM Customer WHERE userId = ?";
    String currentPassword = "";
    String currentEmail = "";

    try {
        getConnection();
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userName);
        ResultSet rst = pstmt.executeQuery();

        if (rst.next()) {
            currentPassword = rst.getString("password");
            currentEmail = rst.getString("email");
        }
    } catch (SQLException ex) {
        out.println("<p>Error: " + ex.getMessage() + "</p>");
    } finally {
        closeConnection();
    }
%>

<form method="POST" action="editAccount.jsp">
    <div align="center">
        <label for="firstName">First Name:</label>
        <input type="text" name="firstName" value="<%= rst.getString("firstName") %>" required><br><br>

        <label for="lastName">Last Name:</label>
        <input type="text" name="lastName" value="<%= rst.getString("lastName") %>" required><br><br>

        <label for="email">Email:</label>
        <input type="email" name="email" value="<%= currentEmail %>" required><br><br>

        <label for="phone">Phone:</label>
        <input type="text" name="phone" value="<%= rst.getString("phonenum") %>" required><br><br>

        <label for="address">Address:</label>
        <input type="text" name="address" value="<%= rst.getString("address") %>" required><br><br>

        <label for="password">New Password:</label>
        <input type="password" name="password"><br><br>

        <label for="confirmPassword">Confirm New Password:</label>
        <input type="password" name="confirmPassword"><br><br>

        <button type="submit">Save Changes</button>
    </div>
</form>

<%
    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean hasError = false;
        String errorMessage = "";

        if (!password.isEmpty() && !password.equals(confirmPassword)) {
            hasError = true;
            errorMessage = "Passwords do not match.";
        }

        if (!hasError) {
            try {
                getConnection();
                String updateSql = "UPDATE Customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?";
                
                // Include password update only if it's not empty
                if (!password.isEmpty()) {
                    updateSql += ", password = ?";
                }
                
                updateSql += " WHERE userId = ?";
                
                PreparedStatement pstmt = con.prepareStatement(updateSql);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, email);
                pstmt.setString(4, phone);
                pstmt.setString(5, address);
                
                // Set password only if it's provided
                if (!password.isEmpty()) {
                    pstmt.setString(6, password);
                    pstmt.setString(7, userName);
                } else {
                    pstmt.setString(6, userName);
                }

                pstmt.executeUpdate();
                out.println("<p>Account details updated successfully!</p>");
            } catch (SQLException ex) {
                out.println("<p>Error: " + ex.getMessage() + "</p>");
            } finally {
                closeConnection();
            }
        } else {
            out.println("<p style='color: red;'>Error: " + errorMessage + "</p>");
        }
    }
%>

</body>
</html>