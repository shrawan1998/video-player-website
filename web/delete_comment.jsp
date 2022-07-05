<%-- 
    Document   : delete_comment
    Created on : 13 Mar, 2022, 1:54:14 AM
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
        if(request.getParameter("code").length()!=0 || request.getParameter("videocode").length()!=0){
            String cmt_code=request.getParameter("code");
            String videocode=request.getParameter("videocode");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                PreparedStatement ps=cn.prepareStatement("delete from comments where (comt_code=? AND videocode=?)");
                ps.setString(1, cmt_code);
                ps.setString(2, videocode);
                if(ps.executeUpdate()>0){
                    out.print("deleted");
                }
                else{
                    out.print("again");
                }
                int count_comments=0;
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select count(*) from comments where videocode='"+videocode+"'");
                if(rs.next()){
                    count_comments=rs.getInt(1);
                }
                out.print("-"+count_comments);
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