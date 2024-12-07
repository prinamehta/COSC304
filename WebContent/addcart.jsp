<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null) { // No products currently in list, create a new list
    productList = new HashMap<String, ArrayList<Object>>();
}

// Get product information from request parameters
String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
Integer quantity = new Integer(1); // Default quantity is 1 if not specified

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);   // Product ID
product.add(name);  // Product Name
product.add(price); // Product Price
product.add(quantity); // Product Quantity

// Update quantity if the same item is added to the cart again
if (productList.containsKey(id)) {
    // If product already exists in the cart, update its quantity
    product = productList.get(id);  // Get the existing product entry
    int curAmount = ((Integer) product.get(3)).intValue();  // Get the current quantity
    product.set(3, new Integer(curAmount + 1));  // Increment quantity by 1
} else {
    // Add new product to the cart
    productList.put(id, product);
}

// Save the updated product list in the session
session.setAttribute("productList", productList);

// Redirect to the cart page
response.sendRedirect("showcart.jsp");
%>