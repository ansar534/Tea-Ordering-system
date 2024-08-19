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
<h1>Past Orders</h1>
    <%
        String customerName = request.getParameter("customerName");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tea_ordering_system", "root", "tea");
            PreparedStatement ps = con.prepareStatement("SELECT customer_name, tea_type, quantity, total_amount FROM orders WHERE customer_name = ?");
            ps.setString(1, customerName);
            ResultSet rs = ps.executeQuery();

            out.println("<table border='1'>");
            out.println("<tr><th>Customer Name</th><th>Tea Type</th><th>Quantity</th><th>Total Amount</th></tr>");
            
            if (rs == null || !rs.next()) {
                out.println("<tr><td colspan='4'>No past orders found for customer: " + customerName + "</td></tr>");
            } else {
                do {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("customer_name") + "</td>");
                    out.println("<td>" + rs.getString("tea_type") + "</td>");
                    out.println("<td>" + rs.getInt("quantity") + "</td>");
                    out.println("<td>" + rs.getDouble("total_amount") + "</td>");
                    out.println("</tr>");
                } while (rs.next());
            }

            out.println("</table>");

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.html");
        }
    %>
    <button onclick="window.location.href='index.html'">Return to Home</button>
</body>
</html>
