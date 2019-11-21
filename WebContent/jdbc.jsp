<%
/**
A JSP file that encapsulates all database access.

Public methods:
- public void getConnection() throws SQLException
- public ResultSet executeQuery(String query) throws SQLException
- public void executeUpdate(String query) throws SQLException
- public void closeConnection() throws SQLException  
**/
%>
<%@ page import="java.sql.*"%>
<%!
	// TODO: Modify database/user connection info
	// User id, password, and server information
	private String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_fill-in;";
	private String uid = "fill-in";
	private String pw = "fill-in";

	// Connection
	private Connection con = null;
%>
<%!
	public void getConnection() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, uid, pw);
	}
   
	public void closeConnection()
	{
		try {
			if (con != null)
				con.close();
			con = null;	
		}
		catch (SQLException e)
		{ /* Ignore connection close error */ }
	}
%>