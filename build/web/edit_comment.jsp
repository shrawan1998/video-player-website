<%-- 
    Document   : edit_comment
    Created on : 14 Mar, 2022, 12:32:47 AM
    Author     : skbag
--%>

<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page contentType="text/html" import="java.sql.*, java.util.LinkedList, java.util.Collections" pageEncoding="UTF-8"%>
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
        if(request.getParameter("code").length()==0 || request.getParameter("txt").length()==0){
            out.print("Try Again");
        }
        else{
            String cmt_code=request.getParameter("code");
            String text=request.getParameter("txt");
            try{
                //generating date
                DateFormat sdf=new SimpleDateFormat("HH:mm dd-MM-yyyy");
                sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));
                java.util.Date d=new java.util.Date();
                String dat=sdf.format(d)+"";
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                PreparedStatement ps=cn.prepareStatement("update comments set comment=?, dt=? where comt_code=?");
                ps.setString(1, text);
                ps.setString(2, dat);
                ps.setString(3, cmt_code);
                if(ps.executeUpdate()>0){
                    out.print("edited");
                }
                else{
                    out.print("Try again");
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