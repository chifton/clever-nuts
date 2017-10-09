<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<CleverNuts.Models.RecupAccountModel>" %>

<asp:Content ID="activeTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="activeContent" ContentPlaceHolderID="MainContent" runat="server">

        <section id="activeForm">
            <h2>Check your email and click on the link in it to activate your nutter account !</h2>
            </section>
</asp:Content>

<asp:Content ID="scriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/jqueryval") %>
</asp:Content>