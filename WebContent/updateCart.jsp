<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true"%>

<%
    String productId = request.getParameter("productId");
    String action = request.getParameter("action");
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList != null && productId != null) {
        ArrayList<Object> product = productList.get(productId);
        if (product != null) {
            Integer quantity = (Integer) product.get(3);
            if ("increase".equals(action)) {
                product.set(3, quantity + 1); // Increase quantity
            } else if ("decrease".equals(action) && quantity > 1) {
                product.set(3, quantity - 1); // Decrease quantity
            }
        }
    }

    session.setAttribute("productList", productList);
    response.sendRedirect("showcart.jsp"); // Redirect back to the cart page
%>
