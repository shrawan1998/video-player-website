<%-- 
    Document   : video_play
    Created on : 3 Mar, 2022, 11:56:11 PM
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
        if(request.getParameter("code").length()==0){
            response.sendRedirect("creater_home.jsp");
        }
        else{
            String videocode=request.getParameter("code");
            %>
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="description" content="">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
                <!-- Title -->
                <title>Video Player Website</title>
                <!-- Favicon -->
                <link rel="icon" href="img/core-img/favicon1.ico">
                <!-- Stylesheet -->
                <link rel="stylesheet" href="style.css">
                <script src="jquery-3.6.0.min.js"></script>
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
                                    if(data.length==6){
                                        $(".fa.fa-heart").css("color","red");
                                    }
                                    else{
                                        $(".fa.fa-heart").css("color","");
                                    }
                                }
                        );
                    });
                    $(document).ready(function(){
                        $("button").click(function(){
                            alert("hello");
                            var channel_code=$(this).attr("id");
                            alert(channel_code);
                            $.post(
                                    "subscribe.jsp",{code:channel_code},function(data){
                                        alert(data+" "+data.length);
                                        
                                    }
                                );
                        });
                    });
                </script>
                <style>
                    .line{
                        border-bottom: 1px solid wheat;
                        z-index: -1;
                        margin-top: 20px;
                        margin-bottom: 20px;
                    }
                    .row{
                        margin-bottom: 0px;
                        margin-top: 0px;
                        padding-bottom: 0px;
                        padding-top: 0px
                    }
                    .row .col-sm-12 a{
                        margin-top: 20px;
                        margin-right: 100px;
                        font-size: 17px;
                        color: white
                    }
                    .row .col-sm-12 .channel-name{
                        margin-bottom: 20px;
                        margin-left: 10px;
                        font-size: 25px;
                        color: red
                    }
                    .row .col-sm-12 button{
                        margin-right: 10px;
                        float: right;
                    }
                    #title{
                        margin-top: 10px;
                    }
                    #title a{
                        font-size: 30px;
                    }
                    @media only screen and (max-width: 600px){
                        .row .col-sm-12 a{
                            margin-top: 20px;
                            margin-right: 88px;
                            font-size: 17px
                        }
                    }
                </style>
            </head>

            <body>
                <!-- ##### Header Area Start ##### -->
                <header class="header-area">
                    <!-- Navbar Area -->
                    <div class="vizew-main-menu" id="sticker">
                        <div class="classy-nav-container breakpoint-off">
                            <div class="container">
                                <!-- Menu -->
                                <nav class="classy-navbar justify-content-between" id="vizewNav">

                                    <!-- Nav brand -->
                                    <a href="index.jsp" class="nav-brand"><img src="logo1.png" class="img-responsive" width="50px" alt=""></a>

                                    <!-- Navbar Toggler -->
                                    <div class="classy-navbar-toggler">
                                        <span class="navbarToggler"><span></span><span></span><span></span></span>
                                    </div>

                                    <div class="classy-menu">

                                        <!-- Close Button -->
                                        <div class="classycloseIcon">
                                            <div class="cross-wrap"><span class="top"></span><span class="bottom"></span></div>
                                        </div>

                                        <!-- Nav Start -->
                                        <div class="classynav">
                                            <ul>
                                                <li><a style="cursor:pointer" data-toggle="modal" data-target="#user_info_Modal"><img src="3.jpg" class="img rounded-circle" width="60px"></a></li>
                                                <li class="active"><a href="creater_home.jsp"><i class="fa fa-home" aria-hidden="true"></i> Home</a></li>
                                                <li><a href="creater_home.jsp"><i class="fa fa-dashboard" aria-hidden="true"></i> Dashboard</a></li>
                                                <li><a href="logout.jsp"><i class="fa fa-power-off" aria-hidden="true"></i> Logout</a></li>
                                            </ul>
                                        </div>
                                        <!-- Nav End -->
                                    </div>
                                </nav>
                            </div>
                        </div>
                    </div>
                </header>
                <!----- Header Area End---- -->
                <!-- Hero Area Start -->
                <!-- The Modal Start-->
                <div class="container">
                    <div class="modal fade" id="user_info_Modal">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <!-- Modal Header -->
                                <div class="modal-header" style="background-color:#db4437">
                                    <h4 class="modal-title">User Profile</h4>
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                </div>
                                <!-- Modal body -->
                                <div class="modal-body">
                                    <div>
                                        <label><img src="3.jpg" class="img rounded" width="70px"/></label>
                                    </div>
                                    <div>
                                        <label style="color:black;font-size:15px">Name: </label>&nbsp;<label style="color:black;font-size:15px">Aayush Kumar</label>
                                    </div>
                                    <div>
                                        <label style="color:black;font-size:15px">Email: </label>&nbsp;<label style="color:black;font-size:15px">aayush@gmail.com</label>
                                    </div>
                                    <a href="edit_profile.jsp"><button type="submit" class="btn btn-danger">Edit Profile</button></a>
                                </div>
                                <!-- Modal footer -->
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-----Modal End-------->
                <!----video part start------->
                <%
                    try{
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                        Statement st=cn.createStatement();
                        ResultSet rs=st.executeQuery("select * from video where code='"+videocode+"'");
                        if(rs.next()){
                            %>
                            <section class="hero-area section-padding-80">
                                <div class="container">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <video class="card-img-top" poster="thumbnails/<%=videocode%>.jpg" style="width:100%;height:100%" controls>
                                                <source src="videos/<%=videocode%>.mkv" alt="Card image" controls>
                                            </video>
                                        </div>
                                    </div>
                                        <%
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
                                        %>
                                        <!-- Post Content -->
                                        
                                    <div class="row">
                                        <div class="col-sm-12" id="title">
                                            <a class="post-title"><%=rs.getString("title")%></a>
                                        </div>
                                    </div>
                                    <div class="row justify-content-center">
                                        <div class="col-sm-12">
                                            <div class="post-meta d-flex">
                                                <a>Like <i id='<%=rs.getString("code")%>' style="cursor:pointer; color:<%=color_like%>" class="fa fa-thumbs-up" aria-hidden="true"></i> <span id="cl-<%=rs.getString("code")%>"><%=count_like%></span></a>
                                                <a>Dislike <i id='<%=rs.getString("code")%>' style="cursor:pointer; color:<%=color_dislike%>" class="fa fa-thumbs-down" aria-hidden="true"></i> <span id="cd-<%=rs.getString("code")%>"><%=count_dislike%></span></a>
                                                <a>Favorite <i id='<%=rs.getString("code")%>' style="cursor:pointer; color:<%=color_fav%>" class="fa fa-heart" aria-hidden="true"></i></a>
                                                <a href="#">Share <i class="fa fa-share" aria-hidden="true"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="line"></div>
                                    <%
                                        String channel_name="";
                                        String channel_code="";
                                        Statement st6=cn.createStatement();
                                        ResultSet rs6=st6.executeQuery("select * from channel where code IN(select ccode from video where code='"+videocode+"')");
                                        if(rs6.next()){
                                            channel_name=rs6.getString("channel_name");
                                            channel_code=rs6.getString("code");
                                        }
                                        Statement stmt=cn.createStatement();
                                        ResultSet rss=stmt.executeQuery("select * from subscribe where user_email='"+email+"'");
                                        if(rss.next()){
                                            %>
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <img src="1.jpg" class="img rounded-circle" width="40px">
                                                    <a class="channel-name"><%=channel_name%></a>
                                                    <button id='<%=channel_code%>' rel="subscription" class="btn btn-primary">SUBSCRIBED</button>
                                                </div>
                                            </div>
                                            <%
                                        }
                                        else{
                                            %>
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <img src="1.jpg" class="img rounded-circle" width="40px">
                                                    <a class="channel-name"><%=channel_name%></a>
                                                    <button id='<%=channel_code%>' rel="subscription" class="btn btn-danger">SUBSCRIBE</button>
                                                </div>
                                            </div>
                                            <%
                                        }
                                    %>
                                    
                                    <div class="line"></div>
                                </div>
                            </section>
                            <%
                        }
                        cn.close();
                    }
                    catch(ClassNotFoundException e){
                        out.println(e.getMessage());
                    }
                    catch(SQLException e){
                        out.println(e.getMessage());
                    }
                %>
                <!-- Hero Area End -->

                <!-- ##### All Javascript Script ##### -->
                <!-- jQuery-2.2.4 js -->
                <script src="js/jquery/jquery-2.2.4.min.js"></script>
                <!-- Popper js -->
                <script src="js/bootstrap/popper.min.js"></script>
                <!-- Bootstrap js -->
                <script src="js/bootstrap/bootstrap.min.js"></script>
                <!-- All Plugins js -->
                <script src="js/plugins/plugins.js"></script>
                <!-- Active js -->
                <script src="js/active.js"></script>

            </body>
            </html>
            <%
        }
    }
%>
