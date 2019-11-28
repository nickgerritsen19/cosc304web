<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<style>
h1 {
	color: #1a8dc7;
}
table {
	align: center;
}
th {
	color: #0c77ad;
}
table, th, td {
  border: 1px solid black;
  border-color: #34aeeb;
  text-align: center;
}
div {
    width: 100%
	text-align: center;
}
h1, h2, h3, td, tr, th {
	font-family: candara, verdana, "Times New Roman";
	text-align: center;
}
a {
	color: #69c6f5;
}
div {
	border: 1px solid black;
	border-color: #34aeeb;
}
</style>
<title>Gerritsen Grocery Order List</title>
</head>

<%@ include file="header.jsp" %>

<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try {	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e) {
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00
String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_cperreau;";
String uid = "cperreau";
String pw = "85322311";

// Make connection
try (Connection con = DriverManager.getConnection(url, uid, pw); 
		Statement stmt = con.createStatement();) { 
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	
	// Write query to retrieve all order summary records
	String sql1 = "SELECT orderId, orderDate, totalAmount, OS.customerId, firstName, lastName"
		+ " FROM ordersummary OS, customer C"
		+ " WHERE OS.customerId = C.customerId ";
	ResultSet rst1 = stmt.executeQuery(sql1);

	out.print("<table border = \"1\" align=\"center\"><tr><th>Order Id</th>"
									  + "<th>Order Date</th>"
									  + "<th>Customer Id</th>"
									  + "<th>Customer Name</th>"
									  + "<th>Total Amount</th></tr>");
	// For each order in the ResultSet
	while (rst1.next()) {
		
		// Print out the order summary information
		out.print("<tr><td>" + rst1.getString("orderId")+"</td><td>"+rst1.getString("orderDate")+"</td><td>"+rst1.getString("customerId")
					+"</td><td>"+rst1.getString("firstName")+" " + rst1.getString("lastName")+"</td><td>"+currFormat.format(rst1.getDouble("totalAmount"))+"</td></tr>");
		// Write a query to retrieve the products in the order
		String sql = "SELECT * "
    			+ "FROM orderproduct "
    			+ "WHERE OrderId = '" + rst1.getString("orderId") + "' ";
		//   - Use a PreparedStatement as will repeat this query many times
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rst2 = pstmt.executeQuery();
		
		out.print("<tr align=\"right\"><td colspan=\"5\"><table border=\"1\" align=\"center\" width=100%" + ">");
		out.print("<th>Product Id</th> <th>Quantity</th> <th>Price</th></tr>");
		// For each product in the order
		while (rst2.next()) {
			// Write out product information
			out.print("<tr><td>"+rst2.getString(2)+"</td><td>"+rst2.getString(3)
			+"</td><td>"+currFormat.format(rst2.getDouble(4))+"</td></tr>");
		}
		out.print("</table></td></tr>");
	}
	out.print("</table>");
} 

// Close connection
catch (SQLException ex) {
	out.println(ex);
}
%>

</body>
</html>

