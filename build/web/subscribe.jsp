<%-- 
    Document   : subscribe
    Created on : 6 Mar, 2022, 10:31:11 PM
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
        if(request.getParameter("code").length()!=0){
            String channel_code=request.getParameter("code");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                String channel_email="";
                Statement stch=cn.createStatement();
                ResultSet rsch=stch.executeQuery("select * from channel where code='"+channel_code+"'");
                if(rsch.next()){
                    channel_email=rsch.getString("email");
                }
                if(email.equals(channel_email)){
                    out.print("can't subscribe");
                }
                else{
                    Statement st=cn.createStatement();
                    ResultSet rs=st.executeQuery("select * from subscribe where (user_email='"+email+"' AND channel_code='"+channel_code+"')");
                    if(rs.next()){
                        PreparedStatement ps=cn.prepareStatement("delete from subscribe where (user_email=? AND channel_code=?)");
                        ps.setString(1, email);
                        ps.setString(2, channel_code);
                        if(ps.executeUpdate()>0){
                            out.print("unsubscribe");
                        }
                        else{
                            out.print("again");
                        }
                    }
                    else{
                        PreparedStatement ps=cn.prepareStatement("insert into subscribe values(?,?)");
                        ps.setString(1, email);
                        ps.setString(2, channel_code);
                        if(ps.executeUpdate()>0){
                            out.print("subscribe");
                        }
                        else{
                            out.print("again");
                        }
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
    }
%>