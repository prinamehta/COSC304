<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
        }
        h3 {
            color: #4caf50;
            margin-top: 20px;
        }
        form {
            margin: 0 auto;
            display: inline-block;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        table {
            margin: 0 auto;
            text-align: left;
        }
        td {
            padding: 10px;
        }
        input[type="text"], input[type="password"] {
            width: 150px;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[type="submit"] {
            background-color: #4caf50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .error-message {
            color: red;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div>
    <h3>Please Login to System</h3>

    <% 
    // Display error message if login fails
    if (session.getAttribute("loginMessage") != null) { 
    %>
        <p class="error-message"><%= session.getAttribute("loginMessage").toString() %></p>
    <% 
    } 
    %>

    <form name="MyForm" method="POST" action="validateLogin.jsp">
        <table>
            <tr>
                <td>
                    <label for="username">Username:</label>
                </td>
                <td>
                    <input type="text" name="username" id="username" maxlength="10" required>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="password">Password:</label>
                </td>
                <td>
                    <input type="password" name="password" id="password" maxlength="10" required>
                </td>
            </tr>
        </table>
        <br>
        <input type="submit" name="Submit2" value="Log In">
    </form>
</div>

</body>
</html>
