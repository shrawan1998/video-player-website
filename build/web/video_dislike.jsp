<%-- 
    Document   : video_dislike
    Created on : 6 Mar, 2022, 2:31:31 PM
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
            String videocode=request.getParameter("code");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select * from video_like where (email='"+email+"' AND videocode='"+videocode+"')");
                if(rs.next()){
                    PreparedStatement ps=cn.prepareStatement("delete from video_like where (email=? AND videocode=?)");
                    ps.setString(1, email);
                    ps.setString(2, videocode);
                    if(ps.executeUpdate()>0){
                        Statement st1=cn.createStatement();
                        ResultSet rs1=st1.executeQuery("select * from video_dislike where (email='"+email+"' AND videocode='"+videocode+"')");
                        if(rs1.next()){
                            PreparedStatement ps1=cn.prepareStatement("delete from video_dislike where (email=? AND videocode=?)");
                            ps1.setString(1, email);
                            ps1.setString(2, videocode);
                            if(ps1.executeUpdate()>0){
                                out.print("white");
                            }
                            else{
                                out.print("again");
                            }
                        }
                        else{
                            String color="blue";
                            PreparedStatement ps2=cn.prepareStatement("insert into video_dislike values(?,?,?)");
                            ps2.setString(1, email);
                            ps2.setString(2, videocode);
                            ps2.setString(3, color);
                            if(ps2.executeUpdate()>0){
                                out.print("blue");
                            }
                            else{
                                out.print("again");
                            }
                        }
                    }
                }
                else{
                    Statement st1=cn.createStatement();
                    ResultSet rs1=st1.executeQuery("select * from video_dislike where (email='"+email+"' AND videocode='"+videocode+"')");
                    if(rs1.next()){
                        PreparedStatement ps1=cn.prepareStatement("delete from video_dislike where (email=? AND videocode=?)");
                        ps1.setString(1, email);
                        ps1.setString(2, videocode);
                        if(ps1.executeUpdate()>0){
                            out.print("white");
                        }
                        else{
                            out.print("again");
                        }
                    }
                    else{
                        String color="blue";
                        PreparedStatement ps2=cn.prepareStatement("insert into video_dislike values(?,?,?)");
                        ps2.setString(1, email);
                        ps2.setString(2, videocode);
                        ps2.setString(3, color);
                        if(ps2.executeUpdate()>0){
                            out.print("blue");
                        }
                        else{
                            out.print("again");
                        }
                    }
                }
                int count_dislike=0;
                Statement st2=cn.createStatement();
                ResultSet rs2=st2.executeQuery("select count(*) from video_dislike where videocode='"+videocode+"'");
                if(rs2.next()){
                    count_dislike=rs2.getInt(1);
                }
                out.print("_"+count_dislike);
                int count_like=0;
                Statement st3=cn.createStatement();
                ResultSet rs3=st3.executeQuery("select count(*) from video_like where videocode='"+videocode+"'");
                if(rs3.next()){
                    count_like=rs3.getInt(1);
                }
                out.print("_"+count_like);
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