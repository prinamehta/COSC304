<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.SQLException" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Product Reviews</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .reviews {
            margin-top: 15px;
            padding: 10px;
            background-color: #f1f1f1;
            border-radius: 8px;
        }
        .review {
            border-bottom: 1px solid #ddd;
            padding: 10px 0;
        }
        .review:last-child {
            border-bottom: none;
        }
        .review-form {
            margin-top: 20px;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 8px;
            display: none;
        }
        .review-form textarea {
            width: 100%;
        }
        .btn-toggle-review-form {
            margin-top: 15px;
        }
    </style>
    <script>
        function toggleReviewForm() {
            const reviewForm = document.getElementById('reviewForm');
            reviewForm.style.display = (reviewForm.style.display === 'none' || reviewForm.style.display === '') ? 'block' : 'none';
        }
    </script>
</head>
<body>

<%@ include file="header.jsp" %>

<%
    int productId = Integer.parseInt(request.getParameter("id")); // Get product ID from URL
    
    String productName = "", productImage = "";
    double productPrice = 0.0;
    
    // SQL query to fetch product details
    String sqlGetProduct = "SELECT productName, productPrice, productImageURL FROM Product WHERE productId = ?";
    
    try {
        getConnection(); // Establish DB connection
        
        // Fetch product details
        PreparedStatement pstmt = con.prepareStatement(sqlGetProduct);
        pstmt.setInt(1, productId);
        
        ResultSet productRst = pstmt.executeQuery();
        if (productRst.next()) {
            productName = productRst.getString("productName");
            productPrice = productRst.getDouble("productPrice");
            productImage = productRst.getString("productImageURL");
        }

        // Fetch existing reviews for the product
        String sqlGetReviews = "SELECT reviewRating, reviewComment, reviewDate FROM Review WHERE productId = ? ORDER BY reviewDate DESC";
        pstmt = con.prepareStatement(sqlGetReviews);
        pstmt.setInt(1, productId);
        ResultSet reviewsRst = pstmt.executeQuery();
        
    %>
        
    <div class="container">
        <h2>Product Reviews for <%= productName %></h2>
        
        <!-- Display product details -->
        <div class="product-details">
            <img src="<%= productImage != null && !productImage.isEmpty() ? productImage : "images/placeholder.jpg" %>" alt="<%= productName %>" style="width: 150px; height: 150px; object-fit: cover;">
            <h4><%= productName %></h4>
            <p>Price: <%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
            
            <!-- Show reviews section -->
            <div class="reviews">
                <h5>Customer Reviews:</h5>
                <%
                    while (reviewsRst.next()) {
                        int reviewRating = reviewsRst.getInt("reviewRating");
                        String reviewComment = reviewsRst.getString("reviewComment");
                        java.sql.Date reviewDate = reviewsRst.getDate("reviewDate");
                %>
                <div class="review">
                    <p><strong>Rating:</strong> <%= reviewRating %> / 5</p>
                    <p><strong>Comment:</strong> <%= reviewComment %></p>
                    <p><strong>Date:</strong> <%= reviewDate %></p>
                </div>
                <% } %>
            </div>

            <!-- Add review button to show the review form -->
            <button class="btn btn-secondary btn-toggle-review-form" onclick="toggleReviewForm()">Add Review</button>

            <!-- Review form to add a new review (Initially hidden) -->
            <div id="reviewForm" class="review-form">
                <form method="POST" action="reviews.jsp?id=<%= id %>">
                    <input type="hidden" name="productId" value="<%= productId %>">
                    <label for="reviewRating">Rating (1-5):</label>
                    <input type="number" id="reviewRating" name="reviewRating" min="1" max="5" required><br><br>
                    <label for="reviewComment">Comment:</label>
                    <textarea id="reviewComment" name="reviewComment" rows="4" required></textarea><br><br>
                    <button type="submit" class="btn btn-primary">Submit Review</button>
                </form>
            </div>

            <!-- Display submitted review -->
            <%
                // Check if a review is submitted
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    int reviewRating = Integer.parseInt(request.getParameter("reviewRating"));
                    String reviewComment = request.getParameter("reviewComment");
                    java.sql.Date reviewDate = new java.sql.Date(System.currentTimeMillis());

                    // Insert the new review into the database
                    String sqlInsertReview = "INSERT INTO Review (productId, reviewRating, reviewDate, reviewComment) VALUES (?, ?, ?, ?)";
                    pstmt = con.prepareStatement(sqlInsertReview);
                    pstmt.setInt(1, productId);
                    pstmt.setInt(2, reviewRating);
                    pstmt.setDate(3, reviewDate);
                    pstmt.setString(4, reviewComment);
                    pstmt.executeUpdate();

                    // Show the submitted review immediately after submission
                    out.println("<div class='review'>");
                    out.println("<p><strong>Rating:</strong> " + reviewRating + " / 5</p>");
                    out.println("<p><strong>Comment:</strong> " + reviewComment + "</p>");
                    out.println("<p><strong>Date:</strong> " + reviewDate + "</p>");
                    out.println("</div>");
                    out.println("<p>Your review has been submitted successfully!</p>");
                }
            %>
        </div>
        
        <!-- Add the "Continue Shopping" button -->
        
    </div>

<%
    } catch (Exception e) {
        // Print the exception message
        out.println("<p>Error: " + e.getMessage() + "</p>");
        
    } finally {
        closeConnection(); // Close DB connection
    }
%>

</body>
</html>