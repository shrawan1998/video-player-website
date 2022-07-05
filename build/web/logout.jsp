<%-- 
    Document   : logout
    Created on : 25 Feb, 2022, 1:40:21 AM
    Author     : skbag
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Cookie c=new Cookie("login","");
    c.setMaxAge(0);
    response.addCookie(c);
    response.sendRedirect("index.jsp");
%>
