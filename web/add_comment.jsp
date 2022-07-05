<%-- 
    Document   : add_comment
    Created on : 11 Mar, 2022, 10:56:23 AM
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
            out.print("Try again");
        }
        else{
            String videocode=request.getParameter("code");
            String text=request.getParameter("txt");
            try{
                //generating date
                SimpleDateFormat sdf=new SimpleDateFormat("HH:mm dd-MM-yyyy");
                sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));
                java.util.Date d=new java.util.Date();
                String dat=sdf.format(d)+"";
                //generating code
                String cmt_code="";
                int sn=0;
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
                    cmt_code+=ls.get(i);
                }
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                String user_name="";
                String user_code="";
                Statement stuser=cn.createStatement();
                ResultSet rsuser=stuser.executeQuery("select * from user_info where email='"+email+"'");
                if(rsuser.next()){
                    user_name=rsuser.getString("name");
                    user_code=rsuser.getString("code");
                }
                //taking max sn from video table
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select MAX(sn) from comments");
                if(rs.next()){
                    sn=rs.getInt(1);
                }
                sn++;
                cmt_code+="-"+sn; //comment code
                PreparedStatement ps=cn.prepareStatement("insert into comments values(?,?,?,?,?,?)");
                ps.setInt(1, sn);
                ps.setString(2, cmt_code);
                ps.setString(3, email);
                ps.setString(4, videocode);
                ps.setString(5, text);
                ps.setString(6, dat);
                if(ps.executeUpdate()>0){
                    %>
                    <div class="old-comment" id="cmt-<%=cmt_code%>">
                        <img src="user_profile/<%=user_code%>.jpg">
                        <div>
                            <h3 style="font-size:13px"><%=user_name%> <span><%=dat%></span></h3>
                            <p id="inedit-<%=cmt_code%>"><%=text%></p>
                            <input id="input-<%=cmt_code%>" type="text" style="display:none">
                            <div class="comment-action">
                                <a class="edit-send" id="send-<%=cmt_code%>" rel='<%=cmt_code%>' style="cursor:pointer; margin-right: 20px; display: none"><i class="fa fa-paper-plane" style="color:blue;font-size: 16px">Send</i></a>
                                <a class="cmt_edit" id="edit-<%=cmt_code%>" pid='<%=cmt_code%>' rel="videocode" style="cursor:pointer"><i class="fa fa-edit" aria-hidden="true" style="font-size:13px; margin-right: 20px">Edit</i></a>
                                <a class="cmt_delete" id='<%=cmt_code%>' rel="<%=videocode%>" style="cursor:pointer"><i class="fa fa-trash" aria-hidden="true" style="color: red; font-size:13px; margin-right: 20px">Delete</i></a>
                            </div>
                        </div>
                    </div>
                    <%
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