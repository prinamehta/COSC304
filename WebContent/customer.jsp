<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            text-align: center;
        }
        h3 {
            color: #904caf;
        }
        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 70%;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        th {
            background-color: #904caf;
            color: white;
            padding: 10px;
            font-size: 14px;
            text-align: left;
        }
        td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #904caf42;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
// Print Customer information
String sql = "select customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password FROM Customer WHERE userid = ?";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{	
    out.println("<h3>Customer Profile</h3>");
	
    getConnection();
    Statement stmt = con.createStatement(); 
    stmt.execute("USE orders");

    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, userName);	
    ResultSet rst = pstmt.executeQuery();
	
    if (rst.next())
    {
        out.println("<table>");
        out.println("<tr><th>Customer Id</th><td>"+rst.getString(1)+"</td></tr>");	
        out.println("<tr><th>First Name</th><td>"+rst.getString(2)+"</td></tr>");
        out.println("<tr><th>Last Name</th><td>"+rst.getString(3)+"</td></tr>");
        out.println("<tr><th>Email</th><td>"+rst.getString(4)+"</td></tr>");
        out.println("<tr><th>Phone</th><td>"+rst.getString(5)+"</td></tr>");
        out.println("<tr><th>Address</th><td>"+rst.getString(6)+"</td></tr>");
        out.println("<tr><th>City</th><td>"+rst.getString(7)+"</td></tr>");
        out.println("<tr><th>State</th><td>"+rst.getString(8)+"</td></tr>");
        out.println("<tr><th>Postal Code</th><td>"+rst.getString(9)+"</td></tr>");
        out.println("<tr><th>Country</th><td>"+rst.getString(10)+"</td></tr>");
        out.println("<tr><th>User Id</th><td>"+rst.getString(11)+"</td></tr>");		
        out.println("</table>");
    }
}
catch (SQLException ex) 
{ 	
    out.println("<p style='color:red;'>"+ex.getMessage()+"</p>"); 
}
finally
{	
    closeConnection();	
}
%>

</body>
</html>
