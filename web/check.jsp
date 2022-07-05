<%-- 
    Document   : check
    Created on : 23 Feb, 2022, 8:56:36 AM
    Author     : skbag
--%>

<%@page contentType="text/html" import="java.sql.*" pageEncoding="UTF-8"%>
<%
    if(request.getParameter("email").length()==0 || request.getParameter("pass").length()==0){
        response.sendRedirect("index.jsp?empty=1");
    }
    else{
        String email=request.getParameter("email");
        String pass=request.getParameter("pass");
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
            Statement st=cn.createStatement();
            ResultSet rs=st.executeQuery("select * from user_info where email='"+email+"'");
            if(rs.next()){
                if(pass.equals(rs.getString("password"))){
                    Cookie c=new Cookie("login",email);
                    c.setMaxAge(3600);
                    response.addCookie(c);
                    Statement st1=cn.createStatement();
                    ResultSet rs1=st1.executeQuery("select * from channel where email='"+email+"'");
                    if(rs1.next()){
                        response.sendRedirect("creater_home.jsp");
                    }
                    else{
                        response.sendRedirect("user_home.jsp");
                    }
                }
                else{
                    response.sendRedirect("index.jsp?invalid_pass=1");
                }
            }
            else{
                response.sendRedirect("index.jsp?invalid_email=1");
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