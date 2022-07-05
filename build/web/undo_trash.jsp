<%-- 
    Document   : undo_trash
    Created on : 2 Mar, 2022, 1:45:50 AM
    Author     : skbag
--%>

<%@page contentType="text/html" import="java.sql.*" pageEncoding="UTF-8"%>
<%
    Cookie ct[]=request.getCookies();
    String email="";
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
        String code=request.getParameter("code");
        try{
            int status=1;
            Class.forName("com.mysql.jdbc.Driver");
            Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
            PreparedStatement ps=cn.prepareStatement("update video set status=? where code=?");
            ps.setInt(1, status);
            ps.setString(2, code);
            if(ps.executeUpdate()>0){
                out.print("success");
            }
            else{
                out.print("again");
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
%>
