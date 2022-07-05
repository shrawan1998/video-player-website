<%-- 
    Document   : incomplete
    Created on : 2 Mar, 2022, 1:06:57 AM
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
        <!-- font-awesome css-->
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="style.css">
        <script src="jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                $(".edit").click(function () {
                    var code = $(this).attr("id");
                    $("#edit_video_Modal").modal("show");
                    $("#thumbEdit").attr("action", "update_thumbnail.jsp?code=" + code);
                    $("#vidEdit").attr("action", "update_video.jsp?code=" + code);
                    $("#infoEdit").attr("action", "update_vidInfo.jsp?code=" + code);
                });
            });
            $(document).on("click",".delete",function(){
                var code = $(this).attr("id");
                $.post(
                        "partial_delete.jsp",{code:code},function(data){
                            if(data.length == 10){
                                $("#r-"+code).fadeOut(1000);
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
                <a href="video_upload.jsp"><i class="material-icons">videocam</i><span style="cursor: pointer">Upload</span></a>
                <a href="trash.jsp"><i class="material-icons">delete</i><span>Trash</span></a>
                <a href="creater_latest.jsp"><i class="material-icons">more_time</i><span>Latest</span></a>
                <a class="active" href="incomplete.jsp"><i class="material-icons">incomplete_circle</i><span>Incomplete</span></a>
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
            
            <!--------edit video modal---->
            <div class="modal fade" id="edit_video_Modal">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <!-- Modal Header -->
                        <div class="modal-header" style="background-color:#db4437">
                            <h4>Edit Video</h4>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <!-- Modal body -->
                        <div class="modal-body">
                            <form method="post" id="infoEdit">
                                <div class="form-group">
                                    <span>Update Title:</span><input type="text" name="title" class="form-control" placeholder="Title....">
                                    <span>Update Description:</span><textarea rows="3" cols="50" name="description" class="form-control" placeholder="Video description...." style="resize: none"></textarea>
                                    <button type="submit" class="btn btn-primary" id="btn">Update</button>
                                </div>
                            </form><hr/>

                            <form method="post" enctype="multipart/form-data" id="thumbEdit">
                                <div class="form-group">
                                    <span>Update Thumbnail:</span><br><input type="file" name="thumbnail" >
                                    <button type="submit" class="btn btn-primary">Update</button>
                                </div>
                            </form><hr/>

                            <form method="post" enctype="multipart/form-data" id="vidEdit">
                                <div class="form-group">
                                    <span>Update Video:</span><br><input type="file" name="video">
                                    <button type="submit" class="btn btn-primary">Update</button>
                                </div>
                            </form>
                        </div>
                        <!-- Modal footer -->
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!---The Modal end-->
        <!-----videos------>
        <div class="videos-container">
            <div class="list-container">
                <%
                    Statement st = cn.createStatement();
                    ResultSet rs = st.executeQuery("select * from video where email='"+email+"' order by dt desc limit 4");
                    while(rs.next()){
                        //taking channel name
                        String channel_name="";
                        Statement stmt=cn.createStatement();
                        ResultSet rss=stmt.executeQuery("select * from channel where code IN(select ccode from video where code='"+rs.getString("code")+"')");
                        if(rss.next()){
                            channel_name=rss.getString("channel_name");
                        }
                        %>
                        <div class="vid-list" id="r-<%=rs.getString("code")%>">
                            <a href="play-video.html"><img src="thumbnails/<%=rs.getString("code")%>.jpg" class="thumbnail" alt=""></a>
                            <div class="flex-div">
                                <img src="images/Jack.png">
                                <div class="vid-info">
                                    <a href="play-video.html"><%=rs.getString("title")%></a>
                                    <p><%=channel_name%></p>
                                    <p>15k Views &bull; 2 days</p>
                                </div>
                            </div>
                            <div class="vid-edit">
                                <a class="edit" id='<%=rs.getString("code")%>' style="cursor:pointer"><i class="fa fa-edit" aria-hidden="true"></i>Edit</a>
                                <a class="delete" id='<%=rs.getString("code")%>' style="cursor:pointer"><i class="fa fa-trash" aria-hidden="true"></i>Delete</a>
                            </div>
                        </div>
                        <%
                    }
                    cn.close();
                %>
            </div>
        </div>
        <script src="jquery-3.6.0.min.js"></script>
        <!-- Popper js -->
        <script src="js/bootstrap/popper.min.js"></script>
        <!-- Bootstrap js -->
        <script src="js/bootstrap/bootstrap.min.js"></script>
        <!-- All Plugins js -->
        <script src="js/plugins/plugins.js"></script>
        <!-- custom js -->
        <script src="script.js"></script>
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