<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
String sql = "SELECT * FROM customer WHERE userid = ?";

try 
{
	getConnection();
	
	PreparedStatement stmt = con.prepareStatement(sql);
	stmt.setString(1, userName);
	ResultSet rst = stmt.executeQuery();
	rst.next();
	
	out.println("<h3>Customer Profile</h3>");
	out.println("<table class=\"table\" border=\"1\">");
	out.println("<tr><th>Id</th><td>"+ rst.getString("customerId") +"</td></tr>");
	out.println("<tr><th>First Name</th><td>"+rst.getString("firstName")+"</td></tr>");
	out.println("<tr><th>Last Name</th><td>"+rst.getString("lastName")+"</td></tr>");
	out.println("<tr><th>Email</th><td>"+rst.getString("email")+"</td></tr>");
	out.println("<tr><th>Phone</th><td>"+rst.getString("phonenum")+"</td></tr>");
	out.println("<tr><th>Address</th><td>"+rst.getString("address")+"</td></tr>");
	out.println("<tr><th>City</th><td>"+rst.getString("city")+"</td></tr>");
	out.println("<tr><th>State</th><td>"+rst.getString("state")+"</td></tr>");
	out.println("<tr><th>Postal Code</th><td>"+rst.getString("postalCode")+"</td></tr>");
	out.println("<tr><th>Country</th><td>"+rst.getString("country")+"</td></tr>");
	out.println("<tr><th>User id</th><td>"+rst.getString("userid")+"</td></tr>");
	out.println("</table>");
} 
catch (SQLException ex) {
	out.println(ex);
}
finally
{
	closeConnection();
}	
// Make sure to close connection
%>

</body>
</html>

