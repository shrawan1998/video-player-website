<%-- 
    Document   : update_vidInfo
    Created on : 28 Feb, 2022, 2:38:52 PM
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
        if(request.getParameter("title").length()==0 || request.getParameter("description").length()==0){
            response.sendRedirect("upload_video.jsp?empty=1");
        }
        else{
            String code=request.getParameter("code");
            String title=request.getParameter("title");
            String description=request.getParameter("description");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                PreparedStatement ps=cn.prepareStatement("update video set title=?, description=? where code=?");
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, code);
                if(ps.executeUpdate()>0){
                    response.sendRedirect("dashboard.jsp?success=1");
                }
                else{
                    response.sendRedirect("dashboard.jsp?again=1");
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
