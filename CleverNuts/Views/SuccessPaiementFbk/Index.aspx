﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2 style="text-align : center; color : white;">Congratulations !<br />You bought 30 <%=  ViewBag.nomitem %> (1 quantity) at <%=  ViewBag.montantcool %> <%=  ViewBag.devisecool %>.<br />Your paiement with ID <%=  ViewBag.identifiantcool %> succeded.<br />You can now save squirrels !</h2>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>
