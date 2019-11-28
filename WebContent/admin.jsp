<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<!-- TODO: Include files auth.jsp and jdbc.jsp -->
<%@ include file="jdbc.jsp"%>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="header.jsp" %>

<%
// TODO: Write SQL query that prints out total order amount by day
String sql = "SELECT CAST(orderDate AS DATE) AS day, SUM(totalAmount) AS dailyTotal from ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY CAST(orderDate AS DATE) ASC";


try 
{
	getConnection();
	
	out.println("<h3>Administrator Sales Report by Day</h3>");
	out.println("<table class=\"table\" border=\"1\">");
	out.println("<tr><th>Order Date</th><th>Total Order Amount</th>");
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	
	PreparedStatement stmt = con.prepareStatement(sql);
	ResultSet rst = stmt.executeQuery();
	while(rst.next()){
		out.println("<tr><td>"+ rst.getString("day") + "</td><td>" + currFormat.format(rst.getDouble("dailyTotal")) + "</td></tr>");
	}
	out.println("</table>");

} 
catch (SQLException ex) {
	out.println(ex);
}
finally
{
	closeConnection();
}	

%>

</body>
</html>

