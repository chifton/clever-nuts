<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Message
</asp:Content>
 
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
    <div class="tab_container">
        <div id="contact" class="tab_content">
            <div class="content_area">
                <div class="content_icon"></div>
                <h1>Contact</h1>
                <div class="hr"></div>
                <div>
                    <h2 style="color:white;"><%= Html.Encode(Model.Title) %></h2>
                    <p style="color:white;"><%= Html.Encode(Model.Content) %></p>
                </div>
            </div>
        </div>
    </div>
 
</asp:Content>