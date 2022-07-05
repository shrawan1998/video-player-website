<%-- 
    Document   : channel_pass
    Created on : 23 Feb, 2022, 9:52:43 PM
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
        if(request.getParameter("channel_name").length()==0 || request.getParameter("category").equals("Select Category")){
            response.sendRedirect("create_channel.jsp?empty=1");
        }
        else{
            String channel_name=request.getParameter("channel_name");
            String category=request.getParameter("category");
            int sn=0, status=1;
            String code="";
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
            for(int i=0; i<=5; i++){
                code+=ls.get(i);
            }
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select MAX(sn) from channel");
                if(rs.next()){
                    sn=rs.getInt(1);
                }
                sn++;
                code+="_"+sn;

                PreparedStatement ps=cn.prepareStatement("insert into channel values(?,?,?,?,?,?,?)");
                ps.setInt(1, sn);
                ps.setString(2, code);
                ps.setString(3, channel_name);
                ps.setString(4, category);
                ps.setInt(5, status);
                ps.setString(6, dat);
                ps.setString(7, email);
                if(ps.executeUpdate()>0){
                    response.sendRedirect("dashboard.jsp");
                }
                else{
                    response.sendRedirect("create_channel.jsp?again=1");
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
