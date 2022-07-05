<%-- 
    Document   : add_favorite
    Created on : 6 Mar, 2022, 7:55:00 PM
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
        if(request.getParameter("code").length()!=0){
            String videocode=request.getParameter("code");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select * from video_favorite where (email='"+email+"' AND videocode='"+videocode+"')");
                if(rs.next()){
                    PreparedStatement ps=cn.prepareStatement("delete from video_favorite where (email=? AND videocode=?)");
                    ps.setString(1, email);
                    ps.setString(2, videocode);
                    if(ps.executeUpdate()>0){
                        out.print("white");
                    }
                    else{
                        out.print("again");
                    }
                }
                else{
                    String color="red";
                    PreparedStatement ps=cn.prepareStatement("insert into video_favorite values(?,?,?)");
                    ps.setString(1, email);
                    ps.setString(2, videocode);
                    ps.setString(3, color);
                    if(ps.executeUpdate()>0){
                        out.print("red");
                    }
                    else{
                        out.print("again");
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