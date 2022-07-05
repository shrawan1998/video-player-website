<%-- 
    Document   : register_record
    Created on : 23 Feb, 2022, 9:43:57 AM
    Author     : skbag
--%>

<%@page import="java.util.Collections"%>
<%@page contentType="text/html" import="java.sql.*, java.util.LinkedList" pageEncoding="UTF-8"%>
<%
    if(request.getParameter("name").length()==0 || request.getParameter("email").length()==0 || request.getParameter("pass").length()==0){
        response.sendRedirect("register.jsp?empty=1");
    }
    else{
        String name=request.getParameter("name");
        String email=request.getParameter("email");
        String pass=request.getParameter("pass");
        int sn=0;
        String code="";
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
            Statement st=cn.createStatement();
            ResultSet rs=st.executeQuery("select MAX(sn) from user_info");
            if(rs.next()){
                sn=rs.getInt(1);
            }
            sn++;
            code+="_"+sn;
            
            PreparedStatement ps=cn.prepareStatement("insert into user_info values(?,?,?,?,?)");
            ps.setInt(1, sn);
            ps.setString(2, code);
            ps.setString(3, name);
            ps.setString(4, email);
            ps.setString(5, pass);
            if(ps.executeUpdate()>0){
                response.sendRedirect("index.jsp?success=1");
            }
            else{
                response.sendRedirect("index.jsp?again=1");
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
