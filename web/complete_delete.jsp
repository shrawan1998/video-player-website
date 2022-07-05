<%-- 
    Document   : complete_delete
    Created on : 2 Mar, 2022, 1:59:34 AM
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
        if(request.getParameter("code").length()==0){
            response.sendRedirect("trash.jsp?empty=1");
        }
        else{
            String code=request.getParameter("code");//video code
            try{
                int status=2;
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                PreparedStatement ps=cn.prepareStatement("update video set status=? where (code=? AND email=?)");
                ps.setInt(1, status);
                ps.setString(2, code);
                ps.setString(3, email);
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
    }
%>