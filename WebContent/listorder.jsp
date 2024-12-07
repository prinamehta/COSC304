<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Glam & Glow Order List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            text-align: center;
        }
        h1 {
            color: #904caf;
        }
        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 90%;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        th {
            background-color: #8466bb;
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
            background-color: #8466bb3a;
        }
        .nested-table {
            width: 100%;
            border: 1px solid #ccc;
        }
        .nested-table th {
            background-color: #8466bb;
        }
    </style>
</head>
<body>

<h1>Order List</h1>

<%
String sql = "SELECT orderId, O.CustomerId, totalAmount, firstName+' '+lastName, orderDate FROM OrderSummary O, Customer C WHERE "
        + "O.customerId = C.customerId";

NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

try  
{	
    getConnection();
    Statement stmt = con.createStatement(); 			
    stmt.execute("USE orders");
	
    ResultSet rst = stmt.executeQuery(sql);		
    out.print("<table><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
	
    // Use a PreparedStatement as will execute many times
    sql = "SELECT productId, quantity, price FROM OrderProduct WHERE orderId=?";
    PreparedStatement pstmt = con.prepareStatement(sql);
	
    while (rst.next())
    {	
        int orderId = rst.getInt(1);
        out.print("<tr><td>"+orderId+"</td>");
        out.print("<td>"+rst.getString(5)+"</td>");
        out.print("<td>"+rst.getInt(2)+"</td>");		
        out.print("<td>"+rst.getString(4)+"</td>");
        out.print("<td>"+currFormat.format(rst.getDouble(3))+"</td>");
        out.println("</tr>");

        // Retrieve all the items for an order
        pstmt.setInt(1, orderId);				
        ResultSet rst2 = pstmt.executeQuery();
		
        out.println("<tr><td colspan=\"5\" align=\"center\">");
        out.println("<table class=\"nested-table\">");
        out.println("<tr><th>Product Id</th> <th>Quantity</th> <th>Price</th></tr>");
        while (rst2.next())
        {
            out.print("<tr><td>"+rst2.getInt(1)+"</td>");
            out.print("<td>"+rst2.getInt(2)+"</td>");
            out.println("<td>"+currFormat.format(rst2.getDouble(3))+"</td></tr>");
        }
        out.println("</table>");
        out.println("</td></tr>");
    }
    out.println("</table>");
}
catch (SQLException ex) 
{ 	
    out.println("<p style='color:red;'>" + ex.getMessage() + "</p>"); 
}
finally
{
    closeConnection();
}
%>

</body>
</html>
