<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <a href="<%= Url.Action("Index", "RulesFr") %>"><img id="langueimage" src="../../Images/drapfrance.jpg" style="margin : auto; text-align : center"/></a>
    <h2 style="text-align : center;">Rules for winning nuts playing Awale</h2>
    <p><ul style="color : white;font-family : Consolas, Courier, monospace;font-size : 12px; font-weight : bold; text-align : center; margin : auto;">
        <li>The game is played by two nutters.</li>
        <img src="../../Images/corne.png" style="margin : auto; text-align : center"/>
        <li>Initially, we have forty-eight nuts or acorns in the twelve holes with four nuts or acorns per hole.</li>
        <img src="../../Images/ecureuil2.png" style="margin : auto; text-align : center"/>
        <li>Players are opposite one another, with a row front of each player. This row will be his camp.</li>
        <img src="../../Images/hiboucool.png" style="margin : auto; text-align : center"/>
        <li>A round is played as follows: the first player takes all the nuts or acorns of a hole of his camp. Then he distribute them in all holes following, also in his opponent camp in the direction of rotation (one nut or acorn in each hole except the departure hole).</li>
        <img src="../../Images/lance.png" style="margin : auto; text-align : center"/>
        <li>If the last nut or acorn falls into a hole of the other side and there are now two or three nuts or acorns in the hole, the player wins them. Then he looks at the previous hole: if it is in the opposite camp and contains two or three nuts or acorns, he wins them too, and so on, until he came to his side or until there is a different number of nuts or acorns from two or three.</li>
        <img src="../../Images/awale_1.png" style="margin : auto; text-align : center"/>
        <li>The goal is to win the most nuts or acorns at the end of the game.</li>
        <img src="../../Images/lancebouleOr.png" style="margin : auto; text-align : center"/>
        <li>The game ends when one player has captured at least 25 nuts or acorns, or more than half, or when there are only 6 nuts or acorns in the game.</li>
       </ul>
    </p>
        <h2 style="text-align : center;">Rules for saving squirrels</h2>
        <p><ul style="color : white;font-family : Consolas, Courier, monospace;font-size : 12px; font-weight : bold; text-align : center;">
        <li>No rules nutters ! Just save squirrels by shooting owls ! But do not do it really :)</li>
        </ul>
        </p>

    <h3><ul style="border : double 1px red; color : white;font-family : Consolas, Courier, monospace;font-size : 20px; font-weight : bold; text-align : center;">
        <li>DO NOT DISABLE JAVASCRIPT. CLEVER NUTS USES IT !</li>
        </ul>
        </h3>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>
