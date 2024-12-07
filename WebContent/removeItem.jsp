<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>

<%
// Get the current list of products from the session
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null) {
    productList = new HashMap<String, ArrayList<Object>>();
}

// Read parameters
String id = request.getParameter("id");

if (id != null && !id.isEmpty()) {
    // Remove product with the given id from the cart
    productList.remove(id);

    session.setAttribute("productList", productList);
}

response.sendRedirect("showcart.jsp"); // Redirect back to cart page
%>