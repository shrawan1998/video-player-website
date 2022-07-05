<%-- 
    Document   : play_video
    Created on : 3 Mar, 2022, 11:56:11 PM
    Author     : skbag
--%>

<%@page import="java.util.TimeZone"%>
<%@page contentType="text/html" import="java.sql.*,java.text.*,java.util.Date" pageEncoding="UTF-8"%>
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
        if(request.getParameter("code").length()==0){
            response.sendRedirect("creater_home.jsp");
        }
        else{
            String videocode=request.getParameter("code");
            String url="";
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web", "root", "");
                Statement sturl = cn.createStatement();
                ResultSet rsurl = sturl.executeQuery("select * from channel where email='"+email+"'");
                if(rsurl.next()){
                    url="creater_home.jsp";
                }
                else{
                    url="user_home.jsp";
                }
                %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Play video</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.6.3/css/all.css'>
    <script src="jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="style3.css">
    <script>
        $(document).on("click",".fa.fa-thumbs-up",function(){
            var code=$(this).attr("id");
            var num_like=0;
            var num_dislike=0;
            $.post(
                    "video_like.jsp",{code:code},function(data){
                        var dt=data.split("-");
                        var clr_like=dt[0];
                        num_like=dt[1];
                        num_dislike=dt[2];
                        $("#cl-"+code).text(num_like);
                        $("#cd-"+code).text(num_dislike);
                        clr_like=$.trim(clr_like);
                        if(clr_like=="blue"){
                            $(".fa.fa-thumbs-up").css("color","blue");
                            $(".fa.fa-thumbs-down").css("color","");
                        }
                        else if(clr_like=="white"){
                            $(".fa.fa-thumbs-up").css("color","");
                        }
                    }
                );
        });
        $(document).on("click",".fa.fa-thumbs-down",function(){
            var code=$(this).attr("id");
            var num_dislike=0;
            var num_like=0;
            $.post(
                    "video_dislike.jsp",{code:code},function(data){
                        var dt=data.split("_");
                        var clr_dislike=dt[0];
                        num_dislike=dt[1];
                        num_like=dt[2];
                        $("#cd-"+code).text(num_dislike);
                        $("#cl-"+code).text(num_like);
                        clr_dislike=$.trim(clr_dislike);
                        if(clr_dislike=="blue"){
                            $(".fa.fa-thumbs-down").css("color","blue");
                            $(".fa.fa-thumbs-up").css("color","");
                        }
                        else if(clr_dislike=="white"){
                            $(".fa.fa-thumbs-down").css("color","");
                        }
                    }
                );
        });
        $(document).on("click",".fa.fa-heart",function(){
            var code=$(this).attr("id");
            $.post(
                    "add_favorite.jsp",{code:code},function(data){
                        var dt=$.trim(data);
                        if(dt=="red"){
                            $(".fa.fa-heart").css("color","red");
                        }
                        else if(dt=="white"){
                            $(".fa.fa-heart").css("color","");
                        }
                    }
            );
        });
        $(document).on("click","#watch_later",function(){
            var code=$(this).attr("rel");
            $.post(
                    "add_watchlater.jsp",{code:code},function(data){
                        var dt=$.trim(data);
                        if(dt=="inserted"){
                            $("#watch_later").attr("class","fa fa-check");
                            $("#save-"+code).text("Saved");
                        }
                        else if(dt=="removed"){
                            $("#watch_later").attr("class","fa fa-folder-plus");
                            $("#save-"+code).text("Save");
                        }
                    }
            );
        });
        
        $(document).on("click",".cinput",function(){
            $(".comment").css("display","block");
        });
        $(document).on("click",".comment",function(){
            var code=$(this).attr("id");
            var txt=$(".cinput").val();
            $.post(
                    "add_comment.jsp",{code:code, txt:txt},function(data){
                        if(data){
                            $("#comments").prepend(data);
                            $(".cinput").val("");
                            $(".comment").css("display","none");
                        }
                    }
                );
        });
        $(document).on("click",".cmt_delete",function(){
            var cmt_code=$(this).attr("id");
            var video_code=$(this).attr("rel");
            $.post(
                    "delete_comment.jsp",{code:cmt_code,videocode:video_code},function(data){
                        var dt=data.split("-");
                        var cmt_count=dt[1];
                        cmt_count=$.trim(cmt_count);
                        if(data.length==11){
                            $("#cmt-counts").text(cmt_count+" Comments");
                            $("#cmt-"+cmt_code).fadeOut(1000);
                        }
                    }
                );
        });
        $(document).on("click","#subscribe",function(){
            var channel_code=$(this).attr("rel");
            $.post(
                    "subscribe.jsp",{code:channel_code},function(data){
                        var dt=$.trim(data);
                        if(dt=="subscribe"){
                            $("#subscribe").css("background","green");
                            $("#subscribe").text("SUBSCRIBED");
                        }
                        else if(dt=="unsubscribe"){
                            $("#subscribe").css("background","red");
                            $("#subscribe").text("SUBSCRIBE");
                        }
                    }
                );
                
        });
        $(document).on("click",".cmt_edit",function(){
            var cmt_code=$(this).attr("pid");
            var video_code=$(this).attr("rel");
            var txt=$("#inedit-"+cmt_code).text();
            $("#inedit-"+cmt_code).css("display","none");
            $("#input-"+cmt_code).css("display","block");
            $("#edit-"+cmt_code).css("display","none");
            $("#send-"+cmt_code).css("display","block");
            $("#input-"+cmt_code).val(txt);
        });
        $(document).on("click",".edit-send",function(){
            var cmt_code=$(this).attr("rel");
            var txt=$("#input-"+cmt_code).val();
            $.post(
                    "edit_comment.jsp",{code:cmt_code, txt:txt},function(data){
                        var dt=$.trim(data);
                        if(dt=="edited"){
                            $("#inedit-"+cmt_code).css("display","block");
                            $("#input-"+cmt_code).css("display","none");
                            $("#edit-"+cmt_code).css("display","block");
                            $("#send-"+cmt_code).css("display","none");
                            $("#inedit-"+cmt_code).text(txt);
                        }
                    }
                );
        });
    </script>
</head>
<body>
    <!------navbar starts-->
    <nav class="flex-div">
        <div class="nav-left flex-div">
            <img src="images/logo.png" alt="" class="logo">
        </div>
        <div class="nav-middle flex-div">
            <div class="search-box flex-div">
                <input type="text" name="search" placeholder="Type here to search">
                <button class="srch-btn"><i class="material-icons flex-div">search</i></button>
            </div>
        </div>
        <div class="nav-right flex-div">
            <a href="<%=url%>"><i class="material-icons display-this flex-div">home</i></a>
            <a href="logout.jsp"><i class="material-icons flex-div">power_settings_new</i></a>
        </div>
    </nav>
    <!-----navbar ends-->
    <!-----video play container----->
    <div class="videos-container play-container">
        <div class="content-row">
            <div class="content-search">
                
            </div>
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
                
                //saving and updating watch history in history table
                Statement sthis=cn.createStatement();
                ResultSet rshis=sthis.executeQuery("select * from history where (email='"+email+"' AND videocode='"+videocode+"')");
                if(rshis.next()){
                    PreparedStatement pshis=cn.prepareStatement("update history set dt=? where (email=? AND videocode=?)");
                    pshis.setString(1, currentDate);
                    pshis.setString(2, email);
                    pshis.setString(3, videocode);
                    if(pshis.executeUpdate()>0){
                        
                    }
                }
                else{
                    PreparedStatement pshis=cn.prepareStatement("insert into history values(?,?,?)");
                    pshis.setString(1, email);
                    pshis.setString(2, videocode);
                    pshis.setString(3, currentDate);
                    if(pshis.executeUpdate()>0){
                        
                    }
                }
                //saving view in views table
                Statement stvws=cn.createStatement();
                ResultSet rsvws=stvws.executeQuery("select * from views where (email='"+email+"' AND videocode='"+videocode+"')");
                if(rsvws.next()){
                    
                }
                else{
                    PreparedStatement psvws=cn.prepareStatement("insert into views values(?,?)");
                    psvws.setString(1, email);
                    psvws.setString(2, videocode);
                    if(psvws.executeUpdate()>0){
                        
                    }
                }
                //Taking the video from video table
                Statement st=cn.createStatement();
                ResultSet rs=st.executeQuery("select * from video where code='"+videocode+"'");
                if(rs.next()){
                    String channel_name="";
                    String channel_code="";
                    Statement st6=cn.createStatement();
                    ResultSet rs6=st6.executeQuery("select * from channel where code IN(select ccode from video where code='"+videocode+"')");
                    if(rs6.next()){
                        channel_name=rs6.getString("channel_name");
                        channel_code=rs6.getString("code");
                    }
                    String color_like="";
                    Statement st1=cn.createStatement();
                    ResultSet rs1=st1.executeQuery("select * from video_like where (email='"+email+"' AND videocode='"+rs.getString("code")+"')");
                    if(rs1.next()){
                        color_like=rs1.getString("color");
                    }
                    String color_dislike="";
                    Statement st2=cn.createStatement();
                    ResultSet rs2=st2.executeQuery("select * from video_dislike where (email='"+email+"' AND videocode='"+rs.getString("code")+"')");
                    if(rs2.next()){
                        color_dislike=rs2.getString("color");
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
                    String color_fav="";
                    Statement st5=cn.createStatement();
                    ResultSet rs5=st5.executeQuery("select * from video_favorite where (email='"+email+"' AND videocode='"+rs.getString("code")+"')");
                    if(rs5.next()){
                        color_fav=rs5.getString("color");
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
                    String wl_text="";
                    String cls="";
                    Statement stwl=cn.createStatement();
                    ResultSet rswl=stwl.executeQuery("select * from watch_later where (email='"+email+"' AND videocode='"+rs.getString("code")+"')");
                    if(rswl.next()){
                        wl_text="Saved";
                        cls="fa fa-check";
                    }
                    else{
                        wl_text="Save";
                        cls="fa fa-folder-plus";
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
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer;color:<%=color_like%>" class="fa fa-thumbs-up" aria-hidden="true"></i> <span id="cl-<%=rs.getString("code")%>"><%=count_like%></span></a>
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer;color:<%=color_dislike%>" class="fa fa-thumbs-down" aria-hidden="true"></i> <span id="cd-<%=rs.getString("code")%>"><%=count_dislike%></span></a>
                                <a><i id='<%=rs.getString("code")%>' style="cursor:pointer; color:<%=color_fav%>" class="fa fa-heart" aria-hidden="true"></i></a>
                                <a><i rel='<%=rs.getString("code")%>' id='watch_later' style="cursor:pointer" class="<%=cls%>" aria-hidden="true"></i><span id="save-<%=rs.getString("code")%>"><%=wl_text%></span></a>
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
                            <%
                                String subs_color="";
                                String sub_status="";
                                Statement stsub=cn.createStatement();
                                ResultSet rssub=stsub.executeQuery("select * from subscribe where (user_email='"+email+"' AND channel_code='"+channel_code+"')");
                                if(rssub.next()){
                                    subs_color="green";
                                    sub_status="SUBSCRIBED";
                                    %>
                                    <button type="button" rel="<%=channel_code%>" id="subscribe" style="background:<%=subs_color%>"><%=sub_status%></button>
                                    <%
                                }
                                else{
                                    subs_color="red";
                                    sub_status="SUBSCRIBE";
                                    %>
                                    <button type="button" rel="<%=channel_code%>" id="subscribe" style="background:<%=subs_color%>"><%=sub_status%></button>
                                    <%
                                }
                            %>
                        </div>

                        <div class="vid-description">
                            <p><%=rs.getString("description")%></p>
                            <p></p>
                            <hr>
                            <h4 id="cmt-counts"><%=cmt_count%> Comments</h4>

                            <div class="add-comment">
                                <img src="user_profile/user.png">
                                <input class="cinput" type="text" placeholder="Write your comment.....">
                                <a class="comment" id='<%=rs.getString("code")%>' style="cursor:pointer; display: none"><i class="material-icons" style="color:blue">send</i></a>
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
                                                <textarea rows="3" cols="50" id="input-<%=cmt_code%>" style="display:none; resize: none"></textarea>

                                                <div class="comment-action">
                                                    <%
                                                        if(email.equals(cemail)){
                                                            %>
                                                            <a class="edit-send" id="send-<%=cmt_code%>" rel='<%=cmt_code%>' style="cursor:pointer; margin-right: 20px; display: none"><i class="fa fa-paper-plane" style="color:blue;font-size: 16px">Send</i></a>
                                                            <a class="cmt_edit" id="edit-<%=cmt_code%>" pid='<%=rscmt.getString("comt_code")%>' rel="<%=rs.getString("code")%>" style="cursor:pointer"><i class="fa fa-edit" aria-hidden="true" style="font-size:13px; margin-right: 20px"></i></a>
                                                            <a class="cmt_delete" id='<%=rscmt.getString("comt_code")%>' rel="<%=rs.getString("code")%>" style="cursor:pointer"><i class="fa fa-trash" aria-hidden="true" style="color: red; font-size:13px; margin-right: 20px"></i></a>
                                                            <%
                                                        }
                                                    %>
                                                </div>
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
                        Statement stcn=cn.createStatement();
                        ResultSet rscn=stcn.executeQuery("select * from channel where code IN(select ccode from video where code='"+rsrs.getString("code")+"')");
                        if(rscn.next()){
                            cname=rscn.getString("channel_name");
                        }
                        int vws_count=0;
                        Statement st_vws=cn.createStatement();
                        ResultSet rs_vws=st_vws.executeQuery("select count(*) from views where videocode='"+rsrs.getString("code")+"'");
                        if(rs_vws.next()){
                            vws_count=rs_vws.getInt(1);
                        }
                        %>
                        <div class="side-video-list">
                            <a href="creater_play_video.jsp?code=<%=rsrs.getString("code")%>" class="small-thumbnail"><img src="thumbnails/<%=rsrs.getString("code")%>.jpg"></a>
                            <div class="vid-info">
                                <a href="creater_play_video.jsp?code=<%=rsrs.getString("code")%>"><%=rsrs.getString("title")%>"</a>
                                <p><%=cname%></p>
                                <p><%=vws_count%> Views</p>
                            </div>
                        </div>
                        <%
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
                <%
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