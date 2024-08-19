<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="style.css">
    <script>
        function printBill() {
            window.print();
        }
    </script>
</head>
<body>
    <h1>Order Confirmation</h1>
    <%
        String customerName = request.getParameter("customerName");
        String teaType1 = request.getParameter("teaType1");
        int quantity1 = Integer.parseInt(request.getParameter("quantity1"));
        String teaType2 = request.getParameter("teaType2");
        int quantity2 = 0; // Default quantity for tea type 2 is 0
        
        if (teaType2 != null && !teaType2.isEmpty()) {
            quantity2 = Integer.parseInt(request.getParameter("quantity2"));
        }
        
        double pricePerCup1 = getPricePerCup(teaType1);
        double totalAmount1 = pricePerCup1 * quantity1;
        
        double pricePerCup2 = 0.0;
        double totalAmount2 = 0.0;
        
        if (quantity2 > 0) {
            pricePerCup2 = getPricePerCup(teaType2);
            totalAmount2 = pricePerCup2 * quantity2;
        }
        
        double totalAmount = totalAmount1 + totalAmount2;
        
        // Add the customer's order to the orders table
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tea_ordering_system", "root", "tea");
            PreparedStatement ps = con.prepareStatement("INSERT INTO orders (customer_name, tea_type, quantity, total_amount) VALUES (?, ?, ?, ?)");
            
            ps.setString(1, customerName);
            ps.setString(2, teaType1);
            ps.setInt(3, quantity1);
            ps.setDouble(4, totalAmount1);
            ps.executeUpdate();
            
            if (quantity2 > 0) {
                ps.setString(2, teaType2);
                ps.setInt(3, quantity2);
                ps.setDouble(4, totalAmount2);
                ps.executeUpdate();
            }
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    <table>
        <tr>
            <th>Customer Name</th>
            <th>Tea Type</th>
            <th>Quantity</th>
            <th>Total Amount (INR)</th>
        </tr>
        <tr>
            <td rowspan="<%= quantity2 > 0 ? 2 : 1 %>"><%= customerName %></td>
            <td><%= teaType1 %></td>
            <td><%= quantity1 %></td>
            <td><%= totalAmount1 %></td>
        </tr>
        <% if (quantity2 > 0) { %>
        <tr>
            <td><%= teaType2 %></td>
            <td><%= quantity2 %></td>
            <td><%= totalAmount2 %></td>
        </tr>
        <% } %>
        <tr>
            <td colspan="3">Total Amount (INR)</td>
            <td><%= totalAmount %></td>
        </tr>
    </table>
    <button onclick="printBill()">Print Bill</button>
    <button onclick="window.location.href='index.html'">Return to Home</button>

    <%!
        private double getPricePerCup(String teaType) {
            double pricePerCup = 0.0;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tea_ordering_system", "root", "shavim");
                PreparedStatement ps = con.prepareStatement("SELECT price_per_cup FROM tea_types WHERE name = ?");
                ps.setString(1, teaType);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    pricePerCup = rs.getDouble("price_per_cup");
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return pricePerCup;
        }
    %>

</body>
</html>
