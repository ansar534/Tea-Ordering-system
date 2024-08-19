<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean isAuthenticated = false;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tea_ordering_system", "root", "shavim");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM employees WHERE username = ? AND password = ?");
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            isAuthenticated = rs.next();
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (isAuthenticated) {
            response.sendRedirect("index.html");
        } else {
    %>
            <h1>Login Failed</h1>
            <p>Invalid username or password. Please try again.</p>
            <button onclick="window.location.href='login.html'">Back to Login</button>
    <%
        }
    %>
</body>
</html>
