<%@ page import="java.sql.*,java.net.URLEncoder" %>
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
h2 {
	color: #0c77ad;
}
a {
	color: #1268c4;
}
div {
	border: 1px solid black;
	border-color: #34aeeb;
}
</style>
<title>Browse Items</title>
</head>

<%@ include file="header.jsp" %>

<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp" align="center">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try {	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e) {
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_cperreau;";
String uid = "cperreau";
String pw = "85322311";

//Make the connection
try (Connection con = DriverManager.getConnection(url, uid, pw); 
		Statement stmt = con.createStatement();) { 
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	
	String sql;
	if(name == null)
		sql = "SELECT * FROM product ";
	else
		sql = "SELECT * "
			+ "FROM product "
			+ "WHERE productName LIKE '%" + name + "%' ";
	PreparedStatement pstmt = con.prepareStatement(sql);
	ResultSet rst = pstmt.executeQuery();
	
	out.print("<h2>All Products</h2>");
	out.print("<table align=\"center\"><tr><th></th><th>Product Name</th><th>Price</th></tr>");
	// Print out the ResultSet
	while (rst.next()) {
		
		// For each product create a link of the form
		String productId = rst.getString("productId");
		String productName = rst.getString("productName");
		String productPrice = currFormat.format(rst.getDouble("productPrice"));
		// addcart.jsp?id=productId&name=productName&price=productPrice
		String link = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + rst.getDouble("productPrice");
		out.print("<tr><td><a href=\"" + link + "\">Add to Cart</a></td><td><a href=\"product.jsp?id=" + productId + "\"<font color=\"#0000FF\"> " + productName + "</font></td><td>"+productPrice+"</td></tr>");
	}
	out.print("</table>");

}
// Close connection
catch (SQLException ex) {
	out.println(ex);
}
// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>