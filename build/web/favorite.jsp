<%-- 
    Document   : favorite.jsp
    Created on : 6 Mar, 2022, 8:20:20 PM
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
        $(document).on("click",".remove",function(){
            var code=$(this).attr("id");
            $.post(
                    "remove_favorite.jsp",{code,code},function(data){
                        if(data.length==12){
                            $("#f-"+code).fadeOut(1000);
                        }
                    }
                );
        });
    </script>
    <style>
        hr{
            height: 1px;
            width: 100%;
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
                                    <li><a style="cursor:pointer" data-toggle="modal" data-target="#user_info_Modal"><img src="3.jpg" class="img rounded-circle" width="70px"/></a></li>
                                    <li><a href="creater_home.jsp"><i class="fa fa-home" aria-hidden="true"></i> Home</a></li>
                                    <li class="active"><a href="favorite.jsp"><i class="fa fa-heart" aria-hidden="true"></i> Favorite</a></li>
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
    <!----video part start------->
    <section class="hero-area section-padding-80">
        <div class="container">
            <div class="row">
                <%
                    try{
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web","root","");
                        Statement st=cn.createStatement();
                        ResultSet rs=st.executeQuery("select * from video_favorite where email='"+email+"'");
                        while(rs.next()){
                            String videocode=rs.getString("videocode");
                            Statement st1=cn.createStatement();
                            ResultSet rs1=st1.executeQuery("select * from video where code='"+videocode+"'");
                            if(rs1.next()){
                                %>

                                <div class="col-sm-4" id='f-<%=rs.getString("videocode")%>'>
                                    <div class="single-post-area mb-80">
                                        <!-- Post Thumbnail -->
                                        <div class="card">
                                            <div class="single-feature-post video-post bg-img" style="background-image: url(thumbnails/<%=rs.getString("videocode")%>.jpg)">
                                                <a href="video_play.jsp?code=<%=rs.getString("videocode")%>" class="btn play-btn"><i class="fa fa-play" aria-hidden="true"></i></a>

                                                <!-- Video Duration -->
                                                <span class="video-duration">05.03</span>
                                            </div>
                                        </div>

                                        <!-- Post Content -->
                                        <div class="post-content">
                                            <a href="#" class="post-cata cata-sm cata-danger">Game</a>
                                            <a href="video_play.jsp?code=<%=rs.getString("videocode")%>" class="post-title">Title: <%=rs1.getString("title")%></a>
                                            <div class="post-meta d-flex">
                                                <a class="remove" id='<%=rs.getString("videocode")%>' style="cursor:pointer"><i class="fa fa-trash" aria-hidden="true"></i> Remove</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%
                            }
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
            </div>
        </div>
    </section>
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
%>
