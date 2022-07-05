<%-- 
    Document   : create_channel
    Created on : 23 Feb, 2022, 9:30:13 PM
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
        %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Project</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="style1.css">
    
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
                <a href=""><i class="material-icons flex-div">search</i></a>
            </div>
        </div>
        <div class="nav-right flex-div">
            <a href="dashboard.jsp"><i class="material-icons display-this flex-div">dashboard</i></a>
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
            <a class="active" href="edit_channel.jsp"><i class="material-icons">videocam</i><span>Edit channel</span></a>
            <a href="trash.jsp"><i class="material-icons">delete</i><span>Trash</span></a>
            <a href="creater_latest.jsp"><i class="material-icons">more_time</i><span>Latest</span></a>
            <a href="incomplete.jsp"><i class="material-icons">incomplete_circle</i><span>Incomplete</span></a>
            <hr>
        </div>
        <div class="subscribed-list">
            <h3>SUBSCRIBED</h3>
            <%
                Statement stch=cn.createStatement();
                ResultSet rsch=stch.executeQuery("select * from channel where email IN(select user_email from subscribe where user_email='"+email+"') limit 5");
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
                                <form action="channel_image.jsp?code=<%=rsus.getString("code")%>" method="post" enctype="multipart/form-data">
                                    <div class="form-group1">
                                        <span>Upload Image:</span><br><input type="file" name="photo">
                                        <button type="submit" class="btn btn-success">Upload</button>
                                    </div>
                                </form>
                                <a href="edit_channel.jsp"><button type="submit" class="btn btn-primary">Edit Channel</button></a>
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
    <!------main body-->
    <%
        Statement st=cn.createStatement();
        ResultSet rs=st.executeQuery("select * from channel where email='"+email+"'");
        if(rs.next()){
            %>
            <div class="container-fluid">
                <div class="row justify-content-center">
                    <div class="col-12 col-md-6">
                        <div class="login-content">
                            <!-- Section Title -->
                            <div class="section-heading">
                                <h4>Update your channel!</h4>
                                <hr />
                            </div>
                            <form action="update_channel.jsp" method="post">
                                <div class="form-group">
                                    <span>Channel Name:</span><input type="text" value="<%=rs.getString("channel_name")%>" name="channel_name" class="form-control" placeholder="Enter channel name....">
                                </div>
                                <div class="form-group">
                                    <span>Channel Category:</span>
                                        <select class="form-control" name="category" required>
                                            <option value="<%=rs.getString("category")%>" class="form-control"><%=rs.getString("category")%></option>
                                            <option value="Health">Health</option>
                                            <option value="Education">Education</option>
                                            <option value="Sports">Sports</option>
                                            <option value="Entertainment">Entertainment</option>
                                            <option value="Blog">Blog</option>
                                            <option value="News">News</option>
                                            <option value="Cooking">Cooking</option>
                                            <option value="Gaming">Gaming</option>
                                            <option value="Gardning">Gardening</option>
                                            <option value="Agriculture">Agriculture</option>
                                        </select>
                                </div>
                                <button type="submit" class="btn vizew-btn w-100 mt-30">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <%
        }
    %>

    <script>
        var menuIcon = document.querySelector("#menu");
        var sidebar = document.querySelector(".sidebar");
        var container = document.querySelector(".container");

        menuIcon.onclick = function () {
            sidebar.classList.toggle("small-sidebar");
            container.classList.toggle("large-container");
        }
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
