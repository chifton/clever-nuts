<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<CleverNuts.Models.LocalPasswordModel>" %>

<asp:Content ID="manageTitle" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>

<asp:Content ID="manageContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <script src="../../Scripts/jquery-1.10.2.js"></script>
    <script src="../../Scripts/jquery-ui.js"></script>
    <script src="../../Scripts/jquery.blockUI.js"></script>
  <link rel="stylesheet" href="../../Content/jquery-ui.css" />
        <script type="text/javascript">
        $(function () {
            $("#tabs").tabs();
            $("#tabspaiement").tabs();
        });

        document.addEventListener("DOMContentLoaded", function () {

            var jeveuxacheter = document.querySelector("#paye2");
            jeveuxacheter.addEventListener("click", function () {
                location.href = encodeURI("/Buy/Index?choix=" + encodeURIComponent($("input[name='radioNuts2']:checked").val()));
            });

        });

        </script>

    <div id="tabs">
  <ul>
          <li><a href="#tabs-2">Buy nuts ! - Purchases</a></li>
    <li><a href="#tabs-1">Password change</a></li>
    <li><a href="#tabs-3">Scores</a></li>
  </ul>
 <div id="tabs-2">
         <div id="tabspaiement">
             <ul>
     <li><a href="#tabspaiement-1">Buy Nuts !</a></li>
    <li><a href="#tabspaiement-2">Purchases</a></li>
    </ul>
  <div id="tabspaiement-1">
    <fieldset>
        <ol id="paye">
            <li class="espacement">
                <input type="radio" id="radioSimple2" name="radioNuts2" value="choix1" checked>
                <img alt="Simple" id="nutsSimpleimg2" src="../../Images/simple.png" />
		<span id="scoreSimple2">Package of 30 simple nuts : <span style="color:red;">1 €</span></span>
            </li>
            <li class="espacement">
                <input type="radio" id="radioBronze2" name="radioNuts2" value="choix2">
		<img alt="Bronze" id="nutsBronzeimg2" src="../../Images/bronze.png" />
		<span id="scoreBronze2">Package of 30 bronze nuts : <span style="color:red;">2 €</span></span>
            </li>
            <li class="espacement">
                <input type="radio" id="radioOr2" name="radioNuts2" value="choix3">
                <img alt="Or" id="nutsOrimg2" src="../../Images/gold.png" />
		<span id="scoreOr2">Package of 30 gold nuts : <span style="color:red;">3 €</span></span>
            </li>
            <li class="espacement">
                <input type="radio" id="radioAll2" name="radioNuts2" value="choix4">
		<img alt="Or" id="nutsOrimg2" src="../../Images/gold.png" /><img alt="Bronze" id="nutsBronzeimg2" src="../../Images/bronze.png" /><img alt="Simple" id="nutsSimpleimg2" src="../../Images/simple.png" />
                <span id="scoreAll2">Big Package (30 Gold-Bronze-Simple) : <span style="color:red;">5 €</span></span>
            </li>
        </ol>
        <input id="paye2" type="submit" value="Buy !" />
    </fieldset>
  </div>
  <div id="tabspaiement-2">
      <%: Html.Action("Index","FacturesNutter") %>      
  </div>
             </div>
  </div>
  <div id="tabs-1">
    <section id="manageForm">
    <h2>Manage your account</h2>
    <p class="message-success"><%: (string)ViewBag.StatusMessage %></p>

    <p>You are connected as <strong><%: User.Identity.Name %></strong>.</p>

    <% if (ViewBag.HasLocalPassword) {
        Html.RenderPartial("_ChangePasswordPartial");
    } else {
        Html.RenderPartial("_SetPasswordPartial");
    } %>

    <!--<section id="externalLogins">
        <%//: Html.Action("RemoveExternalLogins") %>

        <h3>Add a external connection</h3>
        <%//: Html.Action("ExternalLoginsList", new { ReturnUrl = ViewBag.ReturnUrl }) %>
    </section>-->
        </section>
  </div>
  <div id="tabs-3">
          <section id="manageForm3">
<h2 style="text-align:center;margin:auto;">Scores - Levels - Best scores</h2>
          <div id ="levelmoi">
<TABLE BORDER="0"> 
  <TR> 
 <TH><img src="../../Images/gold2.png" /></TH>
 <TH><img src="../../Images/bronze2.png" /></TH> 
 <TH><img src="../../Images/simple2.png" /></TH>
 <TH><img src="../../Images/bonus2.png" /></TH> 
  </TR> 
  <TR> 
 <TD> <span> <%: (string)ViewBag.n3 %></span> </TD> 
 <TD> <span> <%: (string)ViewBag.n2 %></span> </TD> 
 <TD> <span> <%: (string)ViewBag.n1 %></span> </TD> 
 <td> <span> <%: (string)ViewBag.b %></span> </td>
  </TR> 
</TABLE> 
          </div>
              <div id ="levelmoi1"><span id="levelgone">"Level Delmagon  <%: (string)ViewBag.levelreached %>"</span></div>
              <div id ="levelmoi2"><span>Best Bonus Nutter : <%: (string)ViewBag.meilleurbonususer %> -> <%: (string)ViewBag.meilleurbonus %></span></div>
              <div id="levelmeilleur">
<span class="floatnutter1"><%: (string)ViewBag.meilleurn3user %><br />
    &nbsp;&nbsp;<%: (string)ViewBag.meilleurn3 %></span>
<span class="floatnutter2"><%: (string)ViewBag.meilleurn2user %><br />
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%: (string)ViewBag.meilleurn2 %></span>
<span class="floatnutter3"><%: (string)ViewBag.meilleurn1user %><br />
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%: (string)ViewBag.meilleurn1 %></span>
              </div>
              </section>
  </div>
</div>
</asp:Content>

<asp:Content ID="scriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/jqueryval") %>
</asp:Content>