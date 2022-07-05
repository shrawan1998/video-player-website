<%-- 
    Document   : play_video
    Created on : 3 Mar, 2022, 11:56:11 PM
    Author     : skbag
--%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page contentType="text/html" import="java.sql.*,java.text.*,java.util.Date" pageEncoding="UTF-8"%>
<%
    if(request.getParameter("code")==null){
        response.sendRedirect("creater_home.jsp");
    }
    else{
        String videocode=request.getParameter("code");
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web", "root", "");
        %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Play video</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>
    <link rel="stylesheet" href="style3.css">
    <script src="jquery-3.6.0.min.js"></script>
    
</head>
<body>
    <!------navbar starts-->
    <nav class="flex-div">
        <div class="nav-left flex-div">
            <img src="images/logo.png" alt="" class="logo">
        </div>
        <div class="nav-middle flex-div">
            <div class="search-box flex-div">
                <input type="text" placeholder="Type here to search">
                <i class="material-icons">search</i>
            </div>
        </div>
        <div class="nav-right flex-div">
            <a href="index.jsp"><i class="material-icons display-this flex-div">home</i></a>
            <a href="#"><i class="material-icons flex-div">account_circle</i></a>
        </div>
    </nav>
    <!-----navbar ends-->
    <div class="videos-container play-container">
        <div class="content-row">
            <%
                //Taking video posting date
                String postDate="";
                Statement st_dt=cn.createStatement();
                ResultSet rs_dt=st_dt.executeQuery("select * from video where code='"+videocode+"'");
                if(rs_dt.next())
                    postDate=rs_dt.getString("dt");
                
                //generating current date
                SimpleDateFormat sdf=new SimpleDateFormat("HH:mm dd-MM-yyyy");
                sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));
                java.util.Date dt=new java.util.Date();
                String currentDate=sdf.format(dt)+"";
                Date date1=null, date2=null;
                date1=sdf.parse(currentDate);
                date2=sdf.parse(postDate);
                long diff=date1.getTime()-date2.getTime();
                int daysBtn=(int)(diff/(1000*60*60*24));
                
                //Taking video from video table
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select * from video where code='"+videocode+"'");
                if(rs.next()){
                    //Taking channel details from channel table
                    String channel_name="";
                    String channel_code="";
                    Statement st6=cn.createStatement();
                    ResultSet rs6=st6.executeQuery("select * from channel where code IN(select ccode from video where code='"+videocode+"')");
                    if(rs6.next()){
                        channel_name=rs6.getString("channel_name");
                        channel_code=rs6.getString("code");
                    }
                    int count_like=0;
                    Statement st3=cn.createStatement();
                    ResultSet rs3=st3.executeQuery("select count(*) from video_like where videocode='"+rs.getString("code")+"'");
                    if(rs3.next()){
                        count_like=rs3.getInt(1);
                    }
                    int count_dislike=0;
                    Statement st4=cn.createStatement();
                    ResultSet rs4=st4.executeQuery("select count(*) from video_dislike where videocode='"+rs.getString("code")+"'");
                    if(rs4.next()){
                        count_dislike=rs4.getInt(1);
                    }
                    //total comment counting from comments table
                    int cmt_count=0;
                    Statement st_ct=cn.createStatement();
                    ResultSet rs_ct=st_ct.executeQuery("select count(*) from comments where videocode='"+rs.getString("code")+"'");
                    if(rs_ct.next()){
                        cmt_count=rs_ct.getInt(1);
                    }
                    int sub_count=0;
                    Statement st_sub=cn.createStatement();
                    ResultSet rs_sub=st_sub.executeQuery("select count(*) from subscribe where channel_code='"+channel_code+"'");
                    if(rs_sub.next()){
                        sub_count=rs_sub.getInt(1);
                    }
                    int views_count=0;
                    Statement st_view=cn.createStatement();
                    ResultSet rs_view=st_view.executeQuery("select count(*) from views where videocode='"+rs.getString("code")+"'");
                    if(rs_view.next()){
                        views_count=rs_view.getInt(1);
                    }
                    %>
                    <div class="play-video">
                        <video controls autoplay>
                            <source src="videos/<%=rs.getString("code")%>.mkv" type="video/mp4">
                        </video>
                        
                        <h3><%=rs.getString("title")%></h3>
                        <div class="play-video-info">
                            <p><%=views_count%> Views &bull; <%=daysBtn%> days ago</p>
                            <div class="actions play-video-info">
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer" class="fa fa-thumbs-up" aria-hidden="true"></i> <span><%=count_like%></span></a>
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer" class="fa fa-thumbs-down" aria-hidden="true"></i> <span><%=count_dislike%></span></a>
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer" class="fa fa-heart" aria-hidden="true"></i></a>
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer" class="fa fa-folder" aria-hidden="true"></i>Save</a>
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer" class="fa fa-share" aria-hidden="true"></i>Share</a>
                            </div>
                        </div>
                        <hr>

                        <div class="publisher">
                            <img src="channel_profile/<%=rs.getString("ccode")%>.jpg">
                            <div>
                                <p><%=channel_name%></p>
                                <span><%=sub_count%> Subscribers</span>
                            </div>
                            <button type="button">SUBSCRIBE</button>
                        </div>

                        <div class="vid-description">
                            <p></p>
                            <p><%=rs.getString("description")%></p>
                            <hr>
                            <h4 id="cmt-counts"><%=cmt_count%> Comments</h4>

                            <div class="add-comment">
                                <img src="user_profile/user.png">
                                <input class="cinput" type="text" placeholder="Write your comment.....">
                            </div>
                            <div id="comments">
                                <%
                                    //taking comments from comments table
                                    Statement stcmt=cn.createStatement();
                                    ResultSet rscmt=stcmt.executeQuery("select * from comments where videocode='"+rs.getString("code")+"' order by sn desc");
                                    while(rscmt.next()){
                                        String cemail=rscmt.getString("email");//comment person email
                                        String cmt_code=rscmt.getString("comt_code");//comment code
                                        //taking user info who commented on video from user_info table
                                        String user_name="";
                                        String user_code="";
                                        Statement stuser=cn.createStatement();
                                        ResultSet rsuser=stuser.executeQuery("select * from user_info where email='"+rscmt.getString("email")+"'");
                                        if(rsuser.next()){
                                            user_name=rsuser.getString("name");
                                            user_code=rsuser.getString("code");
                                        }
                                        %>
                                        <div class="old-comment" id="cmt-<%=rscmt.getString("comt_code")%>">
                                            <img src="user_profile/<%=user_code%>.jpg">
                                            <div>
                                                <h3 style="font-size:13px"><%=user_name%> <span><%=rscmt.getString("dt")%></span></h3>
                                                <p id="inedit-<%=cmt_code%>"><%=rscmt.getString("comment")%></p>
                                            </div>
                                        </div>
                                        <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    <%
                }
            %>
            
            <div class="right-sidebar">
                <%
                    Statement stst = cn.createStatement();
                    ResultSet rsrs = stst.executeQuery("select * from video where (code<>'"+videocode+"' AND status=1)");
                    while(rsrs.next()){
                        String cname="";
                        String ccode="";
                        Statement stcn=cn.createStatement();
                        ResultSet rscn=stcn.executeQuery("select * from channel where code IN(select ccode from video where code='"+rsrs.getString("code")+"')");
                        if(rscn.next()){
                            cname=rscn.getString("channel_name");
                            ccode=rscn.getString("code");
                        }
                        int vws_count=0;
                        Statement st_vws=cn.createStatement();
                        ResultSet rs_vws=st_vws.executeQuery("select count(*) from views where videocode='"+rsrs.getString("code")+"'");
                        if(rs_vws.next()){
                            vws_count=rs_vws.getInt(1);
                        }
                        %>
                        <div class="side-video-list">
                            <a href="user_play_video.jsp?code=<%=rsrs.getString("code")%>" class="small-thumbnail"><img src="thumbnails/<%=rsrs.getString("code")%>.jpg"></a>
                            <div class="vid-info">
                                <a href="user_play_video.jsp?code=<%=rsrs.getString("code")%>"><%=rsrs.getString("title")%>"</a>
                                <p><%=cname%></p>
                                <p><%=vws_count%> Views</p>
                            </div>
                        </div>
                        <%
                    }
                    cn.close();
                %>
            </div>
        </div>
    </div>
</body>
</html>
<%
        }
        catch(ClassNotFoundException e){
            out.println(e.getMessage());
        }
        catch(SQLException e){
            out.println(e.getMessage());
        }
    }
%>