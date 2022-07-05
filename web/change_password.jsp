<%-- 
    Document   : change_password
    Created on : 24 Feb, 2022, 10:40:30 PM
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
            String url="";
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
            <%
                if(url.equals("creater_home.jsp")){
                   %> 
                    <a href="creater_home.jsp"><i class="material-icons">home</i><span>Home</span></a>
                    <a href="dashboard.jsp"><i class="material-icons">dashboard</i><span>Dashboard</span></a>
                    <a href="creater_favourite.jsp"><i class="material-icons">library_add_check</i><span>Favourite</span></a>
                    <a href="creater_history.jsp"><i class="material-icons">history</i><span>History</span></a>
                    <a href="watch_later.jsp"><i class="material-icons">watch_later</i><span>Watch Later</span></a>
                    <a class="active" href="change_password.jsp"><i class="material-icons">password</i><span>Update Password</span></a>
                    <%
                }
                else{
                    %>
                    <a href="user_home.jsp"><i class="material-icons">home</i><span>Home</span></a>
                    <a href="create_channel.jsp"><i class="material-icons">videocam</i><span>Create channel</span></a>
                    <a href="user_favourite.jsp"><i class="material-icons">library_add_check</i><span>Favourite</span></a>
                    <a href="user_history.jsp"><i class="material-icons">history</i><span>History</span></a>
                    <a href="user_liked.jsp"><i class="material-icons">thumb_up</i><span>Liked Videos</span></a>
                    <a class="active" href="change_password.jsp"><i class="material-icons">password</i><span>Update Password</span></a>
                    <%
                }
            %>
            <hr>
        </div>
        <div class="subscribed-list">
            <h3>SUBSCRIBED</h3>
            <%
                Statement stch=cn.createStatement();
                ResultSet rsch=stch.executeQuery("select * from channel where code IN(select channel_code from subscribe where user_email='"+email+"') limit 5");
                while(rsch.next()){
                    %>
                    <a href=""><img src="channel_profile/<%=rsch.getString("code")%>.jpg"><span><%=rsch.getString("channel_name")%></span></a>
                    <%
                }
            %>
        </div>
    </div>
    <!------sidebar ends-->
    <!-- The Modal Start-->
    <div class="container">
        <div class="modal fade" id="user_info_Modal">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <!-- Modal Header -->
                    <div class="modal-header" style="background-color:#db4437">
                        <h4 class="modal-title" style="color:white">User Profile</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <!-- Modal body -->
                    <%
                        Statement stus = cn.createStatement();
                        ResultSet rsus = stus.executeQuery("select * from user_info where email='"+email+"'");
                        if(rsus.next()){
                            %>
                            <div class="modal-body">
                                <div>
                                    <label><img src="user_profile/<%=rsus.getString("code")%>.jpg" class="img rounded" width="70px"/></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Name: </label>&nbsp;<label style="color:gray;font-size:15px"><%=rsus.getString("name")%></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Email: </label>&nbsp;<label style="color:gray;font-size:15px"><%=rsus.getString("email")%></label>
                                </div>
                                <div>
                                    <label style="color:black;font-size:15px">Password: </label>&nbsp;<label style="color:gray;font-size:15px"> <%=rsus.getString("password")%></label>
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
    <!------main video body-->
    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col-12 col-md-6">
                <div class="login-content">
                    <!-- Section Title -->
                    <div class="section-heading">
                        <h4>Update password!</h4>
                        <hr />
                    </div>
                    <%
                    if(request.getParameter("empty")!=null){
                        out.println("<h5 style='color:red; font-family:arial;margin-left: 230px'>All Field Required!</h5>");
                    }
                    else if(request.getParameter("invalid_pass")!=null){
                        out.println("<h5 style='color:red; font-family:arial;margin-left: 230px'>Invalid Current Password!</h5>");
                    }
                    else if(request.getParameter("mismatch")!=null){
                        out.println("<h5 style='color:red; font-family:arial;margin-left: 230px'>Password Mismatched!</h5>");
                    }
                    else if(request.getParameter("success")!=null){
                        out.println("<h5 style='color:green; font-family:arial;margin-left: 230px'>Password Updated!</h5>");
                    }
                    else if(request.getParameter("again")!=null){
                        out.println("<h5 style='color:red; font-family:arial;margin-left: 230px'>Try Again!</h5>");
                    }
                    %>
                    <form action="update_pass.jsp" method="post">
                        <div class="form-group">
                            <span>Current Password:</span><input type="password" name="cpass" class="form-control" placeholder="Enter current password....">
                        </div>
                        <div class="form-group">
                            <span>New Password:</span><input type="password" name="npass" class="form-control" placeholder="Enter new password....">
                        </div>
                        <div class="form-group">
                            <span>Re-type New Password:</span><input type="password" name="rpass" class="form-control" placeholder="Re-enter new password....">
                        </div>
                        <button type="submit" class="btn vizew-btn w-100 mt-30">Submit</button>
                    </form>
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
