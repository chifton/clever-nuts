<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<%if (HttpRuntime.Cache["LoggedInUsers"] != null)
        {%>
        <% List<string> LoggedOnUsers = (List<string>)HttpRuntime.Cache["LoggedInUsers"];
            if(LoggedOnUsers.Count > 0)
                {
                foreach (string user in LoggedOnUsers)
                    {%>
                <div>
                    <%=user%> is logged on
                </div>
                    <%} %>
                    <%} %>
            <%else{
                %> No users logged on
                    <%} %>
                    <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>