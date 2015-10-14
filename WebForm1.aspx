<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="BIMTest.WebForm1" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ADN Viewer Demo</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css"> 
/*看圖*/
    .ddd:active,
    .ddd:focus,
    .ddd:hover{
    cursor:pointer;
    color:red;
    }
    .auto-style1 {
        width: 312px;
    }
    .auto-style2 {
        width: 707px;
    }
</style>
        <link type="text/css" rel="stylesheet" href="https://developer.api.autodesk.com/viewingservice/v1/viewers/style.css" />
        <script type="text/javascript" src="https://developer.api.autodesk.com/viewingservice/v1/viewers/viewer3D.min.js"></script>

        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
<script>


    // Viewer 3D
    var viewer3D;

    // HTML document to access the elements
    var htmlDoc;

    // Viewer Document
    var currentViewerDoc;

    // Document Id that is to be loaded
    var documentId;

    // OAuth
    var auth;

    // Geometry nodes
    var geometryItems;
    var geometryItems_children;

    // For navigation between nodes
    var selectedModelListIndex = 0;
    var currNodes = [];
    var currNode = null;
    var level = 0;

    //// Current Camera parameters
    //var position = [];
    //var target = [];
    //var upVector = [];
    //var aspect = 1.0;
    //var fov = 10;
    ////var orthoHeight = 
    //var isPerspective = true;

    //var explode = 0;

    //var automoveType = 0;

    //// For changing camera position along a chosen direction
    //// X Y or Z
    //var direction;

    ////variable for initialize Viewing service
    //var bFirst;

    //for set token web request
    var xmlhttp;
    // Initialization on load of the page
    function OnInitialize() {
        htmlDoc = document;
        //this function is called only once
        //bFirst = true;
    }

    //function for each refresh
    function OnInitializeViwer() {
        //get the token.
        var token = document.getElementById("hftoken").value; //htmlDoc.getElementById("hftoken").value;

        //set the token
        xmlhttp = new XMLHttpRequest();

        xmlhttp.open('POST', 'https://developer.api.autodesk.com/utility/v1/settoken', false);
        xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        //xmlhttp.onreadystatechange = xmlHttpRequestHandler;
        //xmlhttp.onerror = xmlHttpRequestErrorHandler;
        // xmlhttp.withCredentials = true; // this line of code will not work with Firefox 33.02
        xmlhttp.send("access-token=" + token);

        var options = {};
        options.env = "AutodeskProduction";
        options.accessToken = token;

        geometryItems = null;
        geometryItems_children = null;

        currNodes = [];
        currNode = null;
        level = 0;

        // For navigation between nodes
        selectedModelListIndex = -1;

        Autodesk.Viewing.Initializer(options, function () {

            //if (bFirst == true) {
            var viewerContainer = document.getElementById('3dViewDiv');// htmlDoc.getElementById('3dViewDiv');
            viewer3D = new Autodesk.Viewing.Private.GuiViewer3D(viewerContainer, {});

            viewer3D.initialize();

            //load the document
            Autodesk.Viewing.Document.load(documentId, onSuccessDocumentLoadCB, onErrorDocumentLoadCB);
                        
            viewer3D.setPropertiesOnSelect(false);

            ////set the ghosting status right.
            var cb = document.getElementById("Checkbox_Ghost");
            viewer3D.setGhosting(cb.checked);

            //viewer3D.addEventListener(Autodesk.Viewing.CAMERA_CHANGE_EVENT, cameraChangedEventCB);
        });
    }
    function LoadDocumentBtnClicked() {
      
        //Initialize Viwer
        OnInitializeViwer();       

        //get the document provided by the user
        //documentId = document.getElementById("DocIdTB").value;
        //if (documentId.substring(0, 3) == "urn")
        //    documentId = window.btoa(documentId);
        documentId = document.getElementById("hfurn").value;//documentId;
        ////update the command line text.
        //UpdateCommandLine("Loading document : " + documentId);
    }
    // Document successfully loaded 
    function onSuccessDocumentLoadCB(viewerDocument) {
        //store the varibale in currentViewerDoc.
        currentViewerDoc = viewerDocument;

        //get the root.
        var rootItem = viewerDocument.getRootItem();

        //store in globle variable
        geometryItems = Autodesk.Viewing.Document.getSubItemsWithProperties(rootItem, { 'type': 'geometry', 'role': '3d' }, true);

        if (geometryItems.length > 0) {
            var item3d = viewerDocument.getViewablePath(geometryItems[0]);

            //load the geometry in the viewer.
            viewer3D.addEventListener(Autodesk.Viewing.GEOMETRY_LOADED_EVENT, geometryLoadedEventCB);
            viewer3D.load(item3d);
            level = 0;

            // Add the 3d geometry items to the list
            $("#ModelList").empty()

            $("#NavigateForwardBtn").prop('disabled', false);
            $("#NavigateBackBtn").prop('disabled', true);

            var itemList = document.getElementById('ModelList'); //htmlDoc.getElementById('ModelList');
            for (i = 0; i < geometryItems.length; i++) {
                itemList.add(new Option(geometryItems[i].name, geometryItems[i]));
            }
        }
    }

    // Some error during document load
    function onErrorDocumentLoadCB(errorMsg, errorCode) {
        $('#tree_container').empty();
        //UpdateCommandLine("Unable to load the document : " + documentId + errorMsg);
    }
    function geometryLoadedEventCB(event) {
        //UpdateCommandLine("Geometry loaded event");
        viewer3D.getObjectTree(getObjectTreeCB);
        viewer3D.removeEventListener(Autodesk.Viewing.GEOMETRY_LOADED_EVENT, geometryLoadedEventCB);
    }
    function getObjectTreeCB(result) {

        if (level == 0) {
            geometryItems_children = result.root.children;//result.children;
        }
        else {
            $("#ModelList").empty()
            geometryItems_children = result.children;

            var itemList = document.getElementById('ModelList'); //htmlDoc.getElementById('ModelList');
            for (i = 0; i < geometryItems_children.length; i++) {
                itemList.add(new Option(geometryItems_children[i].name, geometryItems_children[i]));

                currNodes.push(geometryItems_children[i]);
            }
        }
    }
    function Model_selectedItem(modelList) {
        selectedModelListIndex = modelList.selectedIndex;

        if (level == 0) {

            if (selectedModelListIndex < 0)
                selectedModelListIndex = 0;

            var item3d = currentViewerDoc.getViewablePath(geometryItems[selectedModelListIndex]);
            
            // Clear the properties table
            var table = document.getElementById('PropertiesTable')
            while (table.hasChildNodes()) {
                table.removeChild(table.firstChild);
            }

            if (geometryItems_children.length > 0) {
                $("#NavigateForwardBtn").prop('disabled', false);
            }

            // Disable the Back button since this is the first level
            $("#NavigateBackBtn").prop('disabled', true);

        }
        else {
            // Enable the Back button
            $("#NavigateBackBtn").prop('disabled', false);

            currNode = currNodes[selectedModelListIndex];
            var selectedObjectdbId = currNode.dbId;

            var geomItemsChildren = currNode.children;

            // Disable the Forward button if no further child nodes
            if (typeof geomItemsChildren === "undefined") {
                $("#NavigateForwardBtn").prop('disabled', true);
            }
            else if (geomItemsChildren.length == 0) {
                $("#NavigateForwardBtn").prop('disabled', true);
            }
            else {
                $("#NavigateForwardBtn").prop('disabled', false);
            }

            // Isolate, Select the node item
            var e = document.getElementById("OperationSelectionBox");
            var str = e.options[e.selectedIndex].text;

            if (str === "Isolate") {
                //reset firts
                viewer3D.isolateById(selectedObjectdbId);
            }
            else if (str === "Select") {
                // Clear the current selection
                viewer3D.clearSelection();

                // Select the node
                viewer3D.select(selectedObjectdbId);
            }
            else if (str === "Hide") {
                // Clear the current selection
                viewer3D.showAll();

                // Select the node
                viewer3D.hide(currNode);

            }
            else if (str === "show-only") {

                //not yet implemnted
                //viewer3D.hideAll();

                //viewer3D.show(currNode);
            }
            viewer3D.show(currNode);
            var zoomcb = document.getElementById("ZoomCheckbox");
            if (zoomcb.checked == true) {
                // Zoom if needed
                // viewer3D.impl.controls.handleAction(["focus"], selectedObjectdbId);
                viewer3D.fitToView(currNode.dbId);
            }

            // Update the properties of the item that was selected.
            viewer3D.getProperties(selectedObjectdbId, getPropertiesCB);
        }
    }
    //show the properties in the table
    function getPropertiesCB(result) {
        var id = result.dbId;
        var name = result.name;

       // UpdateCommandLine("Getting Properties of object " + name + " (dbId = " + id + ")");

        // Get the properties table
        var propertiesTable = document.getElementById('PropertiesTable')

        // Clear the properties table
        while (propertiesTable.hasChildNodes()) {
            propertiesTable.removeChild(propertiesTable.firstChild);
        }

        // Populate the table with the properties
        for (i = 0; i < result.properties.length; i++) {
            var property = result.properties[i];
            var disName = property.displayName;
            var disValue = property.displayValue;

            var row = propertiesTable.insertRow(i);

            var cell0 = row.insertCell(0);
            var cell1 = row.insertCell(1);

            cell0.innerHTML = disName;
            cell1.innerHTML = disValue;
        }
    }

    //go to chidren of the selected item
    function onNavigateForward() {
        if (level == 0) {
            $("#ModelList").empty();

            var itemList = document.getElementById('ModelList'); // htmlDoc.getElementById('ModelList');
            for (i = 0; i < geometryItems_children.length; i++) {
                itemList.add(new Option(geometryItems_children[i].name, geometryItems_children[i]));

                currNodes.push(geometryItems_children[i]);
            }

        }
        else {
            $("#ModelList").empty();
            var itemList = document.getElementById('ModelList'); // htmlDoc.getElementById('ModelList');

            currNodes = [];
            var geomItemsChildren = currNode.children;
            for (i = 0; i < geomItemsChildren.length; i++) {
                itemList.add(new Option(geomItemsChildren[i].name, geomItemsChildren[i].dbId));
                currNodes.push(geomItemsChildren[i]);
            }
        }

        level = level + 1;
        selectedModelListIndex = -1;

        $("#NavigateForwardBtn").prop('disabled', true);
        $("#NavigateBackBtn").prop('disabled', true);
    }

    //go to parent of the selected item
    function onNavigateBack() {
        if (level == 1) {
            // Add the 3d geometry items to the list
            $("#ModelList").empty();

            viewer3D.clearSelection();
            viewer3D.showAll();

            var itemList = document.getElementById('ModelList'); // htmlDoc.getElementById('ModelList');
            for (i = 0; i < geometryItems.length; i++) {
                itemList.add(new Option(geometryItems[i].name, geometryItems[i].dbId));
            }
        }
        else {
            $("#ModelList").empty();
            var itemList = document.getElementById('ModelList'); //htmlDoc.getElementById('ModelList');

            currNodes = [];
            var geomItemsChildren = currNode.children[0].parent; //currNode.parent.parent.children;
            for (i = 0; i < geomItemsChildren.length; i++) {
                itemList.add(new Option(geomItemsChildren[i].name, geomItemsChildren[i].dbId));
                currNodes.push(geomItemsChildren[i]);
            }
        }

        level = level - 1;
        selectedModelListIndex = -1;

        $("#NavigateForwardBtn").prop('disabled', true);
        $("#NavigateBackBtn").prop('disabled', true);
    }
    function OnChangeOperation() {
        var e = document.getElementById("OperationSelectionBox");
        var str = e.options[e.selectedIndex].text;

        viewer3D.showAll();
    }
    //control Whether to show other objects during isolate
    function OnChangeGhostCheckbox() {

        var cb = document.getElementById("Checkbox_Ghost");
        viewer3D.setGhosting(cb.checked);

        //UpdateCommandLine("Setting ghost objects during isolate = " + cb.checked);
    }
    function UpdateCommandLine(text) {
        //var itemList = htmlDoc.getElementById('OutputMessages');
        //var obj = itemList.add(new Option(text, text));

        //var e = document.getElementById("OutputMessages");
        //e.scrollTop = e.scrollHeight - 20;
    }
</script>
</head>
<%--<body onload="OnInitialize()">--%>
<body>
<form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server" EnablePageMethods="True" />
                <telerik:RadGrid ID="gridEX1" runat="server" Visible="true" Width="100%" ShowStatusBar="true" OnPageIndexChanged="gridEX1_PageIndexChanging" OnPageSizeChanged="gridEX1_PageSizeChanged" OnPreRender="gridEX1_PreRender"
                AllowPaging="True" PageSize="15" OnItemCommand="gridEX1_ItemCommand" OnItemCreated="gridEX1_ItemCreated" OnSelectedIndexChanged="gridEX1_SelectedIndexChanged" OnItemDataBound="gridEX1_ItemDataBound"
                GridLines="None" Skin="Vista" HeaderStyle-HorizontalAlign="Center" HeaderStyle-VerticalAlign="Middle" AllowMultiRowSelection="false" >
                <PagerStyle AlwaysVisible="true" />
   				<ClientSettings EnablePostBackOnRowClick="true" EnableRowHoverStyle="true">
				<%--<ClientEvents OnRowDblClick="gridEX1_RowDblClick" />--%><%--不可用,會load不到檔案--%>
				<Selecting AllowRowSelect="true" />
			</ClientSettings>
                <MasterTableView NoDetailRecordsText="沒有明細資料可顯示。" NoMasterRecordsText="沒有資料可顯示。" DataKeyNames="Modelfile">
                  <ColumnGroups>
                        <telerik:GridColumnGroup HeaderText="估計" Name="Group1" HeaderStyle-HorizontalAlign="Center" />
                        <telerik:GridColumnGroup HeaderText="實際" Name="Group2" HeaderStyle-HorizontalAlign="Center" />                
                  </ColumnGroups>
                  <Columns>
<%--                        <telerik:GridButtonColumn CommandName="LoadModel" Text="Load Model" UniqueName="LoadModelColumn" ItemStyle-HorizontalAlign="Center" HeaderText="Model">
                        </telerik:GridButtonColumn>--%>
                </Columns> 
                </MasterTableView>
            </telerik:RadGrid>
<telerik:RadWindowManager ID="RadWindowManager1" runat="server">
 <Windows>
    <telerik:RadWindow ID="RadWindow1" runat="server" Title="3D圖" Animation="FlyIn" ShowContentDuringLoad="false" InitialBehaviors="Default" Behaviors="Close,Move,Maximize" VisibleStatusbar="false">
     </telerik:RadWindow>
</Windows>
</telerik:RadWindowManager>
<telerik:RadAjaxManager ID="RadAjaxManager" runat="server">
<AjaxSettings>
    <telerik:AjaxSetting AjaxControlID="fg">
        <UpdatedControls>
            <telerik:AjaxUpdatedControl ControlID="fg"/>
            <telerik:AjaxUpdatedControl ControlID="RadWindowManager1"/>
        </UpdatedControls>
    </telerik:AjaxSetting>
    </AjaxSettings>
</telerik:RadAjaxManager>
<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" Skin="WebBlue">
</telerik:RadAjaxLoadingPanel>
        <asp:HiddenField ID="hftoken" runat="server" Value="" />
        <asp:HiddenField ID="hfurn" runat="server" Value="" />
        <asp:Literal ID="literal1" runat="server"></asp:Literal>
</form>
	<telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
    	<script type="text/javascript">
    	    function gridEX1_RowDblClick(sender, eventArgs) {
    	        var MasterTable = $find("<%=gridEX1.ClientID %>").get_masterTableView();
    	        var RowIndex = eventArgs.get_itemIndexHierarchical();
    	        var RowData = MasterTable.get_dataItems()[RowIndex];
    	        var strID = MasterTable.getCellByColumnUniqueName(RowData, "Modelfile").innerHTML;
    	        var oNew = $find("<%=RadWindow1.ClientID%>");
    	        oNew.setUrl("Default.aspx?file=" + strID);
    	        oNew.SetSize(720, 490);
    	        oNew.set_animation(Telerik.Web.UI.WindowAnimation.Slide);
    	        oNew.set_initialBehaviors(Telerik.Web.UI.WindowBehaviors.None);
    	        oNew.set_behaviors(Telerik.Web.UI.WindowBehaviors.Close);
    	        oNew.set_centerIfModal(true);
    	        oNew.set_visibleStatusbar(false);
    	        oNew.set_visibleTitlebar(true);
    	        oNew.set_showContentDuringLoad(true);
    	        oNew.set_centerIfModal(true);
    	        oNew.set_modal(true);
    	        oNew.Show();
            }
    	</script>
        </telerik:RadScriptBlock>
<div id="divShow">
<hr />
<table border="0">
    <tr>
        <td><input type="checkbox" id="ZoomCheckbox" name="ZoomCheckbox" value="Zoom">Zoom</td>
        <td><input id="Checkbox_Ghost" type="checkbox" name="GhostCheckbox" onchange = "OnChangeGhostCheckbox()" value="Show ghost objects in isolate" checked="checked">Show ghost objects in isolate</td>
    </tr>
</table>
<table border="1">
    <tr><td>
        <table>
            <tr>
                <td><input id="NavigateBackBtn" type="button" value="<<" onclick="return onNavigateBack()" style="width: 40px; height: 35px;border-radius: 15px;background-color: #9F9FBF; font-size: large;" /></td>
                <td><select id="OperationSelectionBox" name="D1" onchange="OnChangeOperation();" style="border-style: solid;background-color: #d9e1e0; font-family: Arial, Helvetica, sans-serif; font-size: medium; font-weight: bold; width: 206px; height: 35px;" />
            <option selected>Isolate</option>
            <option>Select</option>
            <option>Hide</option>
        </select></td>
                <td>
                    <input id="NavigateForwardBtn" type="button" value=">>" onclick="return onNavigateForward()" style="height: 35px; width: 40px; border-radius: 15px; background-color: #9F9FBF; font-size: large;">
                </td>
            </tr>
<tr><td colspan="3">
        <select id="ModelList" name="D2" onclick="Model_selectedItem(this);" multiple="multiple" style="border-width: thick; border-style: solid;overflow: scroll; background-color: #C0C0C0; font-family: Arial, Helvetica, sans-serif; font-size: medium; font-weight: bold; height: 505px; width: 298px; border-radius: 15px;"  >
            <option></option>
    </select>
    </td></tr>
        </table>
        </td>
        <td style="width:100%;vertical-align:top central">
            <div style="border-style: solid;height: 520px;position:absolute;top:300px;left:330px;width: 70%; border-radius: 15px; background-color: #C0C0C0;"  id="3dViewDiv">
        </div>
        </td>
    </tr>
</table>
<div>
<span>
<table id="PropertiesTable" border="1" frame="box" style="border-style: solid; width: 268px; height: 183px; overflow: scroll; border-radius: 15px; background-color: #C0C0C0;">
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
</span>
<span>
        <select id="OutputMessages" multiple="multiple" name="D3" style="overflow: scroll; position: fixed; border-style: solid; background-color: #C0C0C0; font-family: Arial, Helvetica, sans-serif; font-size: medium; font-weight: bold; height: 138px; width: 1068px; border-radius: 15px;">
            <option></option>
        </select>
</span>
</div>
</div>
</body>
</html>
