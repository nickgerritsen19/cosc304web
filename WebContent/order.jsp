<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Set" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="lib/StyleSheet.css">
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
<title>Gerritsen Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

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

//Make connection
try (Connection con = DriverManager.getConnection(url, uid, pw); 
		Statement stmt = con.createStatement();) { 
	// Determine if valid customer id was entered
	String sql = "SELECT COUNT(*) FROM customer "
				+ "WHERE customerId = '" + custId + "' ";
	ResultSet rst = stmt.executeQuery(sql);
	rst.next();
	if(rst.getInt(1) != 1)
		out.println("<h1>Invalid customer id.  Go back to the previous page and try again.</h1>");
	
	// Save order information to database
	
	// Determine if there are products in the shopping cart
	else if (productList == null || productList.isEmpty()) 
	{	
		out.println("<H1>Your shopping cart is empty!</H1>");
	} else {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
	    Date date = new Date();
	    
	    float orderTotal = 0;
	    
	    Set<String> keys = productList.keySet();
	    for(String key: keys){
	    	ArrayList<Object> product = (ArrayList<Object>) productList.get(key);
	    	int curAmount = ((Integer) product.get(3)).intValue();
	    	float price = Float.parseFloat(product.get(2).toString());
	    	orderTotal += curAmount * price;
	    }
	    
	    sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES ('" + custId + 
	    				"', '" + formatter.format(date) + "', " + orderTotal + ")";
	    PreparedStatement psmt = con.prepareStatement(sql);
    	psmt.execute();
    	sql = "SELECT TOP 1 orderId, customerId, totalAmount FROM ordersummary ORDER BY orderId DESC";
	    rst = stmt.executeQuery(sql);
		rst.next();
		
		int orderId = rst.getInt("orderId");
		int customerId = rst.getInt("customerId");
		float totalAmount = rst.getFloat("totalAmount");
		
		sql = "SELECT firstName, lastName FROM customer WHERE customerId = '" + customerId + "' ";
	    rst = stmt.executeQuery(sql);
		rst.next();
		
		String firstName = rst.getString("firstName");
		String lastName = rst.getString("lastName");
		
	    
	    for(String key: keys){
	    	ArrayList<Object> product = (ArrayList<Object>) productList.get(key);
	    	String productId = product.get(0).toString();
	    	String price = product.get(2).toString();
	    	int amount = ((Integer) product.get(3)).intValue();
	    	sql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (" + orderId + ", " + productId +
	    			", " + amount + ", " + price + ")";
	    	psmt = con.prepareStatement(sql);
	    	psmt.execute();
	    	
	    }
	    
	    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	    sql = "SELECT orderproduct.productId, quantity, price, productName FROM orderproduct, product WHERE orderId = '" + orderId + "' AND product.productId = orderproduct.productId";
	    rst = stmt.executeQuery(sql);
	    out.print("<div>");
	    out.print("<h1>Your Order Summary</h1>");
	    out.print("<table align=\"center\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
		while(rst.next()) {
			String prodId = rst.getString("productId");
			int quantity = rst.getInt("quantity");
			float prodPrice = rst.getFloat("price");
			float subTotal = (quantity * prodPrice);
			String prodName = rst.getString("productName");
			out.print("<tr><td>" + prodId + "</td><td>" + prodName + "</td><td align=\"center\">" + quantity + "</td><td align=\"right\">" +
			    	currFormat.format(prodPrice) + "</td><td align=\"right\">" + currFormat.format(subTotal) + "</td></tr></tr>");
		};
		out.print("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td><td aling=\"right\">" + currFormat.format(orderTotal) + "</td></tr>");
	    out.print("</table>");
	    out.print("<h2>Order completed.  Will be shipped soon...</h2>");
	    out.print("<h2>Your order reference number is: " + orderId + "</h2>");
	    out.print("<h2>Shipping to customer: " + custId + " Name: " + firstName + " " + lastName + "</h2>");
	    out.print("<h2><a href=\"index.jsp\">Return to shopping</a></h2>");
	    out.print("</div>");
		
		sql = "SELECT productName FROM product ORDER BY productName ASC";
	    rst = stmt.executeQuery(sql);
		rst.next();
		
	    
	    // Store the order ID in session.setAttribute("orderId", orderId);
	    // before insert order summary, check if it exists
	    // if it exists, update, if it does not, then insert it.
	    
	    session.setAttribute("orderId", orderId);
	    
	    session.setAttribute("productList", productList);
	   
		
		//out.println(currFormat.format(5.0));  // Prints $5.00
	    
	    
	 	// replicate list order to display
	 	// clear shopping cart is set productList to null
	 	
	 	if (!productList.isEmpty()) {
	 		session.removeAttribute("productList");
	 	} else {
	 		return;
	 	}
	    
	}
	
	
	
}


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully

catch (SQLException ex) {
	out.println(ex);
}
%>
</BODY>
</HTML>

