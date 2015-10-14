<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="BIMTest.WebForm2" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ADN Viewer Demo</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css"> 
    .ddd:active,
    .ddd:focus,
    .ddd:hover{
    cursor:pointer;
    color:red;
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server" EnablePageMethods="True" />
                <telerik:RadGrid ID="gridEX1" runat="server" Visible="true" Width="100%" ShowStatusBar="true" OnPageIndexChanged="gridEX1_PageIndexChanging" OnPageSizeChanged="gridEX1_PageSizeChanged" OnPreRender="gridEX1_PreRender"
                AllowPaging="True" PageSize="15" OnItemCommand="gridEX1_ItemCommand" OnItemCreated="gridEX1_ItemCreated" OnSelectedIndexChanged="gridEX1_SelectedIndexChanged" OnItemDataBound="gridEX1_ItemDataBound"
                GridLines="None" Skin="Vista" HeaderStyle-HorizontalAlign="Center" HeaderStyle-VerticalAlign="Middle" AllowMultiRowSelection="false" >
                <PagerStyle AlwaysVisible="true" />
   				<ClientSettings EnablePostBackOnRowClick="false" EnableRowHoverStyle="true">
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
</body>
</html>
