<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
     <%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
 <%
        String teaId = request.getParameter("teaId");
        String teaName = request.getParameter("teaName");
        double pricePerCup = Double.parseDouble(request.getParameter("pricePerCup"));
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tea_ordering_system", "root", "tea");
            PreparedStatement ps = con.prepareStatement("INSERT INTO tea_types (id, name, price_per_cup) VALUES (?, ?, ?)");
            ps.setString(1, teaId);
            ps.setString(2, teaName);
            ps.setDouble(3, pricePerCup);
            int rowsAffected = ps.executeUpdate();
            con.close();
            
            if (rowsAffected > 0) {
    %>
                <h1>Tea Type Added Successfully</h1>
                <p>Tea ID: <%= teaId %></p>
                <p>Tea Name: <%= teaName %></p>
                <p>Price per Cup (INR): <%= pricePerCup %></p>
    <%
            } else {
    %>
                <h1>Error Adding Tea Type</h1>
                <p>Failed to add tea type. Please try again.</p>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <h1>Error</h1>
            <p>Failed to add tea type due to an internal error.</p>
    <%
        }
    %>
    <button onclick="window.location.href='add_tea_type.html'">Add Another Tea Type</button>
    <button onclick="window.location.href='index.html'">Return to Home</button>
</body>
</html>
