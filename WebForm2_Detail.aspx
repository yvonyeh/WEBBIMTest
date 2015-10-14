<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm2_Detail.aspx.cs" Inherits="BIMTest.WebForm2_Detail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Autodesk View and Data API DEMO</title>

    <style>
        html, body {
            height: 100%;
        }

        .container {
            height: 100%;
        }

        .fill {
            width: 100%;
            height: 100%;
            min-height: 100%;            
        }

  #progressBackgroundFilter {
position:fixed; 
top:0px; 
bottom:0px; 
left:0px;
right:0px;
overflow:hidden; 
padding:0; 
margin:0; 
background-color:#000; 
filter:alpha(opacity=50); 
opacity:0.5; 
z-index:1000; 
}
#processMessage { 
position:fixed; 
top:30%; 
left:43%;
padding:10px; 
width:9%; 
z-index:1001; 
background-color:#fff;
border:solid 1px #000;
}  
    </style>
    <!--Bootstrap-->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">

    <!-- style sheet of viewer -->
    <link type="text/css" rel="stylesheet" href="https://viewing.api.autodesk.com/viewingservice/v1/viewers/style.css?v=v1.2.15" />
    
            <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="Scripts/jquery-1.11.3.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>

    <!--JS library of viewer-->
    <script type="text/javascript" src="https://developer.api.autodesk.com/viewingservice/v1/viewers/three.min.js?v=v1.2.15"></script>
    <script type="text/javascript" src="https://developer.api.autodesk.com/viewingservice/v1/viewers/viewer3D.min.js?v=v1.2.15"></script>
    <!--A basic extension sample-->
    <script src="Scripts/BasicExtension.js"></script>
    <script src="Scripts/Viewer.js"></script>
<%--                <script type="text/javascript">
                    function test2() {
                        //var obj = $(document.body);
                        //$(obj).find("#urn").val($(obj).find("#hfurn").val());

                        initialize();
                    };
</script>--%>
<script type='text/javascript'>
function divloadingshow() {
  $('#divloadingshow').show();
}
</script>
</head>
<body onload="divloadingshow()">
<div id="divloadingshow">
<div id="progressBackgroundFilter"></div>
<div id="processMessage">
<img alt="Loading" src="../Images/ajax-loader.gif"/>
 處理中，請稍後... 
</div>
</div>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfurn" runat="server" Value="" />
        <asp:Literal ID="literal1" runat="server"></asp:Literal>
<asp:Literal ID="literal2" runat="server"></asp:Literal>
            <%--<asp:TextBox ID="richTextBox1" runat="server" Width="100%" Height="400px" Visible="false"></asp:TextBox>--%>
    </form>
    <div class="container">
        <div id="urn1"></div>
        <div class="row" style="display:none">
            <table class="table table-responsive">
                <tr>
                    <td>
                        <div class="col-lg-12 ">
                            <input class="text-primary col-md-10" id="urn" placeholder="urn here ..." />
                            <button class=" btn btn-primary col-md-2" id="btnLoadModel">Load model</button>
                        </div>
                    </td>
                </tr>    
            </table>
        </div>
        <div class="row fill">
            <div class="col-lg-12 fill ">
                <!--The viewer container -->
                <div id="viewer"></div>
            </div>
        </div>
    </div>
</body>
</html>
