<%-- 
    Document   : update_pass
    Created on : 24 Feb, 2022, 11:01:39 PM
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
        if(request.getParameter("cpass").length()==0 || request.getParameter("npass").length()==0 || request.getParameter("rpass").length()==0){
            response.sendRedirect("change_password.jsp?empty=1");
        }
        else{
            String cpass=request.getParameter("cpass");
            String npass=request.getParameter("npass");
            String rpass=request.getParameter("rpass");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select * from user_info where email='"+email+"'");
                if(rs.next()){
                    if(rs.getString("password").equals(cpass)){
                        if(npass.equals(rpass)){
                            PreparedStatement ps=cn.prepareStatement("update user_info set password=? where email=?");
                            ps.setString(1, npass);
                            ps.setString(2, email);
                            if(ps.executeUpdate()>0){
                                response.sendRedirect("change_password.jsp?success=1");
                            }
                            else{
                                response.sendRedirect("change_password.jsp?again=1");
                            }
                        }
                        else{
                            response.sendRedirect("change_password.jsp?mismatch=1");
                        }
                    }
                    else{
                        response.sendRedirect("change_password.jsp?invalid_pass=1");
                    }
                }
                else{
                    response.sendRedirect("change_password?invalid_email=1");
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