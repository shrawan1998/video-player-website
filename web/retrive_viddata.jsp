<%-- 
    Document   : retrive_viddata
    Created on : 24 Feb, 2022, 11:59:46 PM
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
        if(request.getParameter("title").length()==0 || request.getParameter("description").length()==0){
            response.sendRedirect("video_upload.jsp?empty=1");
        }
        else{
            String title=request.getParameter("title");
            String description=request.getParameter("description");
            int sn=0, status=1;
            String code="", ccode="";
            //generating date
            SimpleDateFormat sdf=new SimpleDateFormat("HH:mm dd-MM-yyyy");
            sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));
            java.util.Date d=new java.util.Date();
            String dat=sdf.format(d)+"";
            //generating code
            LinkedList ls=new LinkedList();
            for(int i=0; i<=9; i++){
                ls.add(new Integer(i));
            }
            for(char i='A'; i<='Z'; i++){
                ls.add(i);
            }
            for(char i='a'; i<='z'; i++){
                ls.add(i);
            }
            Collections.shuffle(ls);
            for(int i=0; i<=6; i++){
                code+=ls.get(i);
            }
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                
                //taking max sn from video table
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select MAX(sn) from video");
                if(rs.next()){
                    sn=rs.getInt(1);
                }
                sn++;
                code+="_"+sn; //video code
                //taking channel code from channel table
                Statement st1=cn.createStatement();
                ResultSet rs1=st1.executeQuery("select code from channel where email='"+email+"'");
                if(rs1.next()){
                    ccode=rs1.getString("code"); //channel code
                }
                PreparedStatement ps=cn.prepareStatement("insert into video values(?,?,?,?,?,?,?,?)");
                ps.setInt(1, sn);
                ps.setString(2, code);
                ps.setString(3, title);
                ps.setString(4, description);
                ps.setString(5, email);
                ps.setString(6, ccode);
                ps.setString(7, dat);
                ps.setInt(8, status);
                if(ps.executeUpdate()>0){
                    response.sendRedirect("upload_vid_thumb.jsp?state=1&code="+code);
                }
                else{
                    response.sendRedirect("video_upload.jsp?again=1");
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