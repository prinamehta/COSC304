<%@ page import="java.sql.*, java.util.regex.Pattern, java.util.regex.Matcher" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account - Glam & Glow</title>
</head>
<body>

<h2 align="center">Create a New Account</h2>

<form method="POST" action="signup.jsp">
    <div align="center">
        <label for="userId">Username:</label>
        <input type="text" name="userId" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" name="password" required><br><br>
        
        <label for="confirmPassword">Confirm Password:</label>
        <input type="password" name="confirmPassword" required><br><br>
        
        <label for="email">Email:</label>
        <input type="email" name="email" required><br><br>

        <label for="firstName">First Name:</label>
        <input type="text" name="firstName" required><br><br>

        <label for="lastName">Last Name:</label>
        <input type="text" name="lastName" required><br><br>

        <label for="phone">Phone Number:</label>
        <input type="text" name="phone" required><br><br>

        <label for="address">Address:</label>
        <input type="text" name="address" required><br><br>

        <label for="city">City:</label>
        <input type="text" name="city" required><br><br>

        <label for="state">State:</label>
        <input type="text" name="state" required><br><br>

        <label for="postalCode">Postal Code:</label>
        <input type="text" name="postalCode" required><br><br>

        <label for="country">Country:</label>
        <input type="text" name="country" required><br><br>

        <button type="submit">Create Account</button>
    </div>
</form>

<%
    // Validate and handle the form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String country = request.getParameter("country");

        boolean hasError = false;
        String errorMessage = "";

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            hasError = true;
            errorMessage = "Passwords do not match.";
        }

        // Validate email format
        Pattern emailPattern = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
        Matcher matcher = emailPattern.matcher(email);
        if (!matcher.matches()) {
            hasError = true;
            errorMessage = "Invalid email format.";
        }

        if (!hasError) {
            try {
                getConnection(); // Assume your database connection method is here

                // Check if user already exists
                String checkSql = "SELECT * FROM customer WHERE userId = ?";
                PreparedStatement checkStmt = con.prepareStatement(checkSql);
                checkStmt.setString(1, userId);
                ResultSet checkResult = checkStmt.executeQuery();
                if (checkResult.next()) {
                    hasError = true;
                    errorMessage = "Username already exists.";
                }

                // Insert new user if no errors
                if (!hasError) {
                    String insertSql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId, password) "
                                     + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement pstmt = con.prepareStatement(insertSql);
                    pstmt.setString(1, firstName);
                    pstmt.setString(2, lastName);
                    pstmt.setString(3, email);
                    pstmt.setString(4, phone);
                    pstmt.setString(5, address);
                    pstmt.setString(6, city);
                    pstmt.setString(7, state);
                    pstmt.setString(8, postalCode);
                    pstmt.setString(9, country);
                    pstmt.setString(10, userId);
                    pstmt.setString(11, password);

                    // Execute insert statement
                    pstmt.executeUpdate();

                    out.println("<p>Account created successfully! You can now <a href='login.jsp'>log in</a>.</p>");
                }
            } catch (SQLException ex) {
                out.println("<p style='color: red;'>Error: " + ex.getMessage() + "</p>");
            } finally {
                closeConnection(); // Assume your close connection method is here
            }
        } else {
            out.println("<p style='color: red;'>Error: " + errorMessage + "</p>");
        }
    }
%>

</body>
</html>