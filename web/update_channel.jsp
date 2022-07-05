<%-- 
    Document   : channel_pass
    Created on : 23 Feb, 2022, 9:55:48 PM
    Author     : skbag
--%>

<%@page contentType="text/html" import="java.sql.*" pageEncoding="UTF-8"%>
<%
    Cookie ct[]=request.getCookies();
    String email=null;
    for(int i=0; i<ct.length; i++){
        if(ct[i].getName().equals("login")){
            email=ct[i].getValue();
            break;
        }
    }
    if(email==null){
        response.sendRedirect("index.jsp");
    }
    else{
        if(request.getParameter("channel_name").length()==0 || request.getParameter("category").length()==0){
            response.sendRedirect("edit_channel.jsp?empty=1");
        }
        else{
            String channel_name=request.getParameter("channel_name");
            String category=request.getParameter("category");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                PreparedStatement ps=cn.prepareStatement("update channel set channel_name=?, category=? where email=?");
                ps.setString(1, channel_name);
                ps.setString(2, category);
                ps.setString(3, email);
                if(ps.executeUpdate()>0){
                    response.sendRedirect("dashboard.jsp?success=1");
                }
                else{
                    response.sendRedirect("edit_channel.jsp?again=1");
                }
                cn.close();
            }
            catch(ClassNotFoundException e){
                out.println(e.getMessage());
            }
            catch(SQLException e){
                out.println(e.getMessage());
            }
        }
    }
%>
