<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<CleverNuts.Models.RecupAccountModel>" %>

<asp:Content ID="activedTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="activedContent" ContentPlaceHolderID="MainContent" runat="server">

        <section id="activedForm">
            <h2>Your nutter account has been activated. You can play !</h2>
            </section>
</asp:Content>

<asp:Content ID="scriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/jqueryval") %>
</asp:Content>