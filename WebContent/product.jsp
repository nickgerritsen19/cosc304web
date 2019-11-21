<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.servlet.http.HttpUtils.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Gerritsen Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<%
// Get product name to search for

//Note: Forces loading of SQL Server driver
try {	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e) {
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_cperreau;";
String uid = "cperreau";
String pw = "85322311";
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

//Make connection
try (Connection con = DriverManager.getConnection(url, uid, pw); 
		Statement stmt = con.createStatement();) { 
	// TODO: Retrieve and display info for the product
	String productId = request.getParameter("id");
	
	String sql = "SELECT productName, productPrice, productImageURL FROM product WHERE productId = '" + productId + "' ";
	PreparedStatement pstmt = con.prepareStatement(sql);
	ResultSet rst = pstmt.executeQuery();
	rst.next();
	String productName = rst.getString("productName");
	Double productPrice = rst.getDouble("productPrice");
	String productImageURL = rst.getString("productImageURL");
	
	out.println("<h2>"+productName+"</h2>");
	out.println("<table><tr>");
	out.println("<th>Id</th><td>"+productId+"</td></tr><tr><th>Price</th><td>"+currFormat.format(productPrice)+"</td></tr>");
	out.println("</table>");
	
	// TODO: If there is a productImageURL, display using IMG tag
	String path = request.getContextPath();
	out.println("<img src=" + path + "/" + productImageURL + ">");
	
	// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
	out.println("<img src=" + path + "/displayImage.jsp?id=" + productId + ">");
	
	// TODO: Add links to Add to Cart and Continue Shopping
	String addCartLink = "addcart.jsp?id=1&name="+productName+"&price="+productPrice;
	out.print("<h3><a href=\""+addCartLink+"\">Add to Cart</a></h3>");
	out.print("<h3><a href=\"listprod.jsp\">Continue Shopping</a>");
}
catch (SQLException ex) {
	out.println(ex);
}
%>

</body>
</html>

