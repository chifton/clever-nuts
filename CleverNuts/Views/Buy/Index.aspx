<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../../Scripts/jquery-1.10.2.js"></script>
    <script src="../../Scripts/jquery-ui.js"></script>
    <script src="../../Scripts/jquery.blockUI.js"></script>
  <link rel="stylesheet" href="../../Content/jquery-ui.css" />
        <script type="text/javascript">

            document.addEventListener("DOMContentLoaded", function () {

                if($("#choixCool").val() == "choix1")
                {
                    $("#panierNutter").text("Basket : 30 simple nuts at 1 €");
                    $("#produitPaypal").val('5DJGWDZBHPNLC');
                    $("#produitWallet").val('543C5950D6EA3');
                }
                else if ($("#choixCool").val() == "choix2") {
                    $("#panierNutter").text("Basket : 30 bronze nuts at 2 €");
                    $("#produitPaypal").val('4EGARP7SHZXWC');
                    $("#produitWallet").val('543C5AE82D4EE');
                }
                else if ($("#choixCool").val() == "choix3") {
                    $("#panierNutter").text("Basket : 30 gold nuts at 3 €");
                    $("#produitPaypal").val('P6Z4J4JANK8U8');
                    $("#produitWallet").val('543C5B6F5B075');
                }
                else if ($("#choixCool").val() == "choix4") {
                    $("#panierNutter").text("Basket : 30 simple, 30 bronze and 30 gold nuts at 5 €");
                    $("#produitPaypal").val('762XHUER3YPVG');
                    $("#produitWallet").val('543C5BE7D6312');
                }
            });
        </script>


    <div id="boxPaiement">
        <!-- CODE DE PAIEMENT PAR HI PAY WALLET -->
        <!--<div id="deuxBuys">
            <img class="inlineclasse" src="../../Images/hipay.png" />
        <form action="https://payment.hipay.com/index/link" method="post" target="_top">
            <input type="hidden" id="produitWallet" name="id" value="" />
            <input type="image" name="hipay_payment_button" src="https://www.hipaywallet.com/images/i18n/en/bt_payment_1.png" />
        </form>
        </div> -->
        <!-- CODE DE PAIEMENT PAR PAYPAL -->
        <div id="threeBuys">
            <img class="inlineclasse" src="../../Images/paypalTrue.png" />
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" id="produitPaypal" name="hosted_button_id" value="">
<input type="image" src="https://www.paypalobjects.com/en_US/GB/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal – The safer, easier way to pay online.">
<img alt="" border="0" src="https://www.paypalobjects.com/fr_FR/i/scr/pixel.gif" width="1" height="1">
</form>
        </div>
        <div id="panierNutter">
        </div>
    </div>
        <input type="hidden" id="choixCool" class="choixCool" name="choixCool" value="<%= ViewBag.monachat %>">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>
