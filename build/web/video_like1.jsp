<%-- 
    Document   : video_like1
    Created on : 3 Mar, 2022, 2:04:28 AM
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
        String videocode=request.getParameter("code");
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
            Statement st1=cn.createStatement();
            ResultSet rs1=st1.executeQuery("select * from video_like where (email='"+email+"' AND videocode='"+videocode+"')");
            if(rs1.next()){
                PreparedStatement ps=cn.prepareStatement("delete from video_like where (email=? AND videocode=?)");
                ps.setString(1, email);
                ps.setString(2, videocode);
                if(ps.executeUpdate()>0){
                    response.sendRedirect("user_home.jsp");
                }
                else{
                    response.sendRedirect("user_home.jsp");
                }
            }
            else{
                String color="blue";
                PreparedStatement ps=cn.prepareStatement("insert into video_like values(?,?,?)");
                ps.setString(1, email);
                ps.setString(2, videocode);
                ps.setString(3, color);
                if(ps.executeUpdate()>0){
                    response.sendRedirect("user_home.jsp");
                }
                else{
                    response.sendRedirect("user_home.jsp");
                }
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
