<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
}

/* Style the header */
.header {
  background-color: #626770;
  padding: 20px;
  text-align: center;
}

.header a {
  display: block;
  color: #52c6cc;
  text-decoration: none;
}

/* Style the top navigation bar */
.topnav {
  overflow: hidden;
  background-color: #333;
}

/* Style the topnav links */
.topnav a {
  float: left;
  display: block;
  color: #f2f2f2;
  font-family: Arial, Helvetica, sans-serif;
  text-align: center;
  padding: 16px 16px;
  text-decoration: none;
}

/* Change color on hover */
.topnav a:hover {
  background-color: #ddd;
  color: black;
}

.topnav p {
  display: block;
  color: #f2f2f2;
  //padding: 14px 16px;
  padding: 0px 14px;
  font-family: Arial, Helvetica, sans-serif;
  text-align: right;
  text-decoration: none;
}
</style>


<div class="header">
  <h1>
  <font face="cursive">
  	<a href ="index.jsp">Clothing Emporium</a>
  	</font>
  </h1>
</div>

<div class="topnav">
  <a href="login.jsp">Log In</a>
  <a href="listprod.jsp">Begin Shopping</a>
  <a href="listorder.jsp">List All Orders</a>
  <a href="customer.jsp">Customer Info</a>
  <a href="admin.jsp">Administrators</a>
  <a href="logout.jsp">Log Out</a>

<%
// TODO: Display user name that is logged in (or nothing if not logged in)	
String username = (String) session.getAttribute("authenticatedUser");
if(username != null) {
	out.println("<p>Signed in as: " + username + "</p>");
}
%>

</div>
