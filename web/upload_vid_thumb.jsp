<%-- 
    Document   : video_upload
    Created on : 26 Feb, 2022, 11:43:18 AM
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
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/videoplayer_web", "root", "");
            String videocode=request.getParameter("code");
            int state=Integer.parseInt(request.getParameter("state"));
        %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Project</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <!-- font-awesome css-->
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="style1.css">
    <script src="jquery-3.6.0.min.js"></script>
</head>

<body>
    <!------navbar starts-->
    <nav class="flex-div">
        <div class="nav-left flex-div">
            <i id="menu" class="material-icons">menu</i>
            <img src="images/logo.png" alt="" class="logo">
        </div>
        <div class="nav-middle flex-div">
            <div class="search-box flex-div">
                <input type="text" placeholder="Search">
                <i class="material-icons">search</i>
            </div>
        </div>
        <div class="nav-right flex-div">
            <a href="video_upload.jsp"><i class="material-icons flex-div">videocam</i></a>
            <a href="logout.jsp"><i class="material-icons flex-div">power_settings_new</i></a>
            <i class="material-icons display-this" data-toggle="modal" data-target="#user_info_Modal">account_circle</i>
        </div>
    </nav>
    <!-----navbar ends-->
    <!-----sidebar starts-->
    <div class="sidebar">
        <div class="shortcut-links">
            <a href="creater_home.jsp"><i class="material-icons">home</i><span>Home</span></a>
            <a href="dashboard.jsp"><i class="material-icons">dashboard</i><span>Dashboard</span></a>
            <a class="active" href="video_upload.jsp"><i class="material-icons">videocam</i><span style="cursor: pointer">Upload</span></a>
            <a href="trash.jsp"><i class="material-icons">delete</i><span>Trash</span></a>
            <a href="latest.jsp"><i class="material-icons">more_time</i><span>Latest</span></a>
            <hr>
        </div>
        <div class="subscribed-list">
            <h3>YOUR CHANNEL</h3>
            <%
                Statement stch=cn.createStatement();
                ResultSet rsch=stch.executeQuery("select * from channel where email='"+email+"'");
                while(rsch.next()){
                    %>
                    <a href=""><img src="channel_profile/<%=rsch.getString("code")%>.jpg"><span><%=rsch.getString("channel_name")%></span></a>
                    <%
                }
            %>
        </div>
    </div>
    <!------sidebar ends-->

    <!------main video body-->
    <div class="container">
        <div class="modal fade" id="user_info_Modal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <!-- Modal Header -->
                    <div class="modal-header" style="background-color:#db4437">
                        <h4 class="modal-title" style="color:white">Channel Profile</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <!-- Modal body -->
                    <%
                        Statement stus = cn.createStatement();
                        ResultSet rsus = stus.executeQuery("select * from channel where email='"+email+"'");
                        if(rsus.next()){
                            %>
                            <div class="modal-body">
                                <div>
                                    <label><img src="channel_profile/<%=rsus.getString("code")%>.jpg" class="img rounded" width="70px"/></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Channel Name: </label>&nbsp;<label style="color:gray;font-size:15px"><%=rsus.getString("channel_name")%></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Channel Category: </label>&nbsp;<label style="color:gray;font-size:15px"><%=rsus.getString("category")%></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Channel Email: </label>&nbsp;<label style="color:gray;font-size:15px"> <%=rsus.getString("email")%></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Created on: </label>&nbsp;<label style="color:gray;font-size:15px"> <%=rsus.getString("dt")%></label>
                                </div>
                            </div>
                            <%
                        }
                    %>
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col-12 col-md-6">
                <div class="login-content">
                    <!-- Section Title -->
                    <div class="section-heading">
                        <h4>Upload video for your channel!</h4>
                        <hr />
                    </div>
                    <%
                        if(state==1){
                            %>
                            <form action="thumbnail_pass.jsp?code=<%=videocode%>" method="post" enctype="multipart/form-data">
                                <div class="form-group">
                                    <span>Upload thumbnail:</span><input type="file" name="video" class="form-control">
                                </div>
                                <button type="submit" class="btn vizew-btn w-100 mt-30">Submit</button>
                            </form><br>
                            <%
                        }
                        else if(state==2){
                            %>
                            <form action="video_pass.jsp?code=<%=videocode%>" method="post" enctype="multipart/form-data">
                                <div class="form-group">
                                    <span>Upload video:</span><input type="file" name="video" class="form-control">
                                </div>
                                <button type="submit" class="btn vizew-btn w-100 mt-30">Submit</button>
                            </form>
                            <%
                        }
                        else if(state==3){
                            %>
                            <h6 style="color: green;margin-left: 230px">Uploaded Successfully!</h6>
                            <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <script>
        var menuIcon = document.querySelector("#menu");
        var sidebar = document.querySelector(".sidebar");
        var container = document.querySelector(".container");

        menuIcon.onclick = function () {
            sidebar.classList.toggle("small-sidebar");
            container.classList.toggle("large-container");
        };
    </script>
    <script src="jquery-3.6.0.min.js"></script>
    <!-- Popper js -->
    <script src="js/bootstrap/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="js/bootstrap/bootstrap.min.js"></script>
    <!-- All Plugins js -->
    <script src="js/plugins/plugins.js"></script>
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

