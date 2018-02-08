<%@ page language="java" %>
<html>
	<head><title>Tomcat7C</title></head>
	<body>
		<h1><font color="red">Tomcat7C.sunny.com</font></h1>
		<table align="centre" border="1">
			<tr>
				<td>Session ID</td>
			<% session.setAttribute("sunny.com","sunny.com"); %>
				<td><%= session.getId() %></td>
			</tr>
			<tr>
				<td>Created on</td>
				<td><%= session.getCreationTime() %></td>
			</tr>
		</table>
	</body>
</html>

