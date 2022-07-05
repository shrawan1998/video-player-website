<%-- 
    Document   : upload_video
    Created on : 24 Feb, 2022, 1:43:47 AM
    Author     : skbag
--%>

<%@page import="java.io.File"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                                <a href="index.html" class="nav-brand"><img src="logo1.png" width="50px" alt=""></a>
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
                                            <li class="active"><a href="dashboard.jsp"><i class="fa fa-home" aria-hidden="true"></i> Home</a></li>
                                            <li><a href="logout.jsp"><i class="fa fa-sign-out" aria-hidden="true"></i> Logout</a></li>
                                            <li><a href="#"><i class="fa fa-commenting" aria-hidden="true"></i> Help</a></li>
                                            <li><a href="#"><i class="fa fa-info-circle" aria-hidden="true"></i> About</a></li>
                                            <li><a href="#"><i class="fa fa-paper-plane" aria-hidden="true"></i> Contact</a></li>
                                        </ul>
                                    </div>
                                    <!-- Nav End -->
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
            </header>
            <!-- ##### Header Area End ##### -->

            <!-- ##### Breadcrumb Area Start ##### -->
            <div class="vizew-breadcrumb">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="dashboard.jsp"><i class="fa fa-home" aria-hidden="true"></i> Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Upload Video</li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
            <!-- ##### Breadcrumb Area End ##### -->

            <!-- ##### Login Area Start ##### -->
            <div class="vizew-login-area section-padding-80">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-12 col-md-6">
                            <div class="login-content">
                                <!-- Section Title -->
                                <div class="section-heading">
                                    <h4>Let's upload video for your channel!</h4>
                                    <div class="line"></div>
                                </div>

                                <form action="retrive_viddata.jsp" method="post">
                                    <div class="form-group">
                                        Title <input type="text" name="title" class="form-control" placeholder="Title....">
                                    </div>
                                    <div class="form-group">
                                        Description <textarea rows="3" cols="50" name="description" class="form-control" placeholder="Video description...." style="resize: none"></textarea>
                                    </div>
                                    <button type="submit" class="btn vizew-btn w-100 mt-30">Submit</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- ##### Login Area End ##### -->

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
