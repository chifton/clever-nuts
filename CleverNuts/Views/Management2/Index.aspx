﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
            <script type="text/javascript" src="../Scripts/jquery-1.8.2.min.js"></script>
            <script src="../../Scripts/jquery.blockUI.js"></script>        
            <script type="text/javascript">

                document.addEventListener("DOMContentLoaded", function () {

                    // Récupération de tous les contrôles de la view
                    var images = document.querySelectorAll(".bonneimage");
                    var image = document.querySelectorAll(".bonneimage2");
                    for (var t = 0; t < images.length; t++) {
                        $(".bonneimage").eq(t).hover(function () {
                            $(this).animate({ width: 400 }, 1, "linear");
                            // Son de bulles pour les boutons
                            soundManager.url = 'swf/';
                            soundManager.onready(function () {
                                soundManager.createSound({
                                    id: 'sonBulle',
                                    url: '/Sounds/bulles.mp3',
                                    autoplay: true,
                                    autoload: true,
                                    loops: 1,
                                    volume: 50
                                });
                            });
                            soundManager.load('sonBulle', {
                                onload: function () {
                                    this.play();
                                }
                            });
                        }, function () {
                            $(this).animate({ width: 274 }, 1, "linear");
                        });
                    }
                    $(".bonneimage2").hover(function () {
                        $(this).animate({ width: 400 }, 1, "linear");
                        // Son de bulles pour les boutons
                        soundManager.url = 'swf/';
                        soundManager.onready(function () {
                            soundManager.createSound({
                                id: 'sonBulle',
                                url: '/Sounds/bulles.mp3',
                                autoplay: true,
                                autoload: true,
                                loops: 1,
                                volume: 50
                            });
                        });
                        soundManager.load('sonBulle', {
                            onload: function () {
                                this.play();
                            }
                        });
                    }, function () { $(this).animate({ width: 290 }, 1, "linear"); });

                    // Trainée de poudre derrière
                    $(document).mousemove(function (e) {
                        var image = $('<img id="traine">');
                        image.attr('src', '../../Images/trainee.png');
                        image.appendTo(document.body);
                        image.css({ "position": "absolute", top: e.pageY + 2, left: e.pageX + 2 }).fadeOut(1200);
                    });


                    // Récupération des champs cachés pour jouer
                    //$("input#awlchamplevelniveau").val()
                    //awlchamptopalealevel


                    // Apparition du hibou et de l'écureuil
                    var tophibouMechant = aleatoire(screen.availHeight);
                    var lefthibouMechant = aleatoire(screen.availWidth);
                    var hibouMechant = $('<img id="HibouMechant">');
                    hibouMechant.attr('src', '../../Images/hibouvolant.gif');
                    $("body").append(hibouMechant);
                    hibouMechant.css({ position: "absolute", left: lefthibouMechant + "px", top: tophibouMechant + "px" });
                    // Son du hibou
                    soundManager.onready(function () {
                        soundManager.createSound({
                            id: 'sonBoubou',
                            url: '/Sounds/hibou.mp3',
                            autoplay: true,
                            autoload: true,
                            loops: 1,
                            volume: 70
                        });
                    });
                    soundManager.load('sonBoubou', {
                        onload: function () {
                            this.play();
                        }
                    });
                    setTimeout(function () {
                        hibouMechant.remove();
                    }, 1500);
                    setInterval(function () {
                        var tophibouMechant = aleatoire(screen.availHeight);
                        var lefthibouMechant = aleatoire(screen.availWidth);
                        var hibouMechant = $('<img id="HibouMechant">');
                        hibouMechant.attr('src', '../../Images/hibouvolant.gif');
                        $("body").append(hibouMechant);
                        hibouMechant.css({ position: "absolute", left: lefthibouMechant + "px", top: tophibouMechant + "px" });
                        // Son du hibou
                        soundManager.onready(function () {
                            soundManager.createSound({
                                id: 'sonBoubou',
                                url: '/Sounds/hibou.mp3',
                                autoplay: true,
                                autoload: true,
                                loops: 1,
                                volume: 70
                            });
                        });
                        soundManager.load('sonBoubou', {
                            onload: function () {
                                this.play();
                            }
                        });
                        setTimeout(function () {
                            hibouMechant.remove();
                        }, 1500);
                    }, 5000);


                    // Fonction de génération aléatoire
                    function aleatoire(N) {
                        return (Math.floor((N) * Math.random() + 1));
                    }

                });
                </script>
                            
    <div class="float-center">

        <% if (Convert.ToString(ViewData["ici"]) == "site") {
                        %>
        <div class="boutons1">
            <a class="boutondisparait" href="<%= Url.Action("Manage", "Account") %>"><img class="bonneimage2" title="You need a nutter account and to be logged in !" src="<%= Url.Content("../../Images/buynuts.png") %>" /></a>
        </div>    <% } else if(Convert.ToString(ViewData["ici"]) == "facebook") { %>
        <div class="boutons1">
            <a class="boutondisparait" href="<%= Url.Action("Manage", "FacebookNutter", new { identifiant = ViewBag.idfbk })%>"><img class="bonneimage2" title="Buy nuts with facebook !" src="<%= Url.Content("../../Images/buynuts.png") %>" /></a>
        </div>
        <% } %>



        <div class="boutons3">
            <a class="boutondisparait" href="<%= Url.Action("Index", "Play") %>"><img alt="Play1" class="bonneimage" src="../../Images/button_play_1.png" /></a>
            <a class="boutondisparait" href="<%= Url.Action("Index", "Play2", new { levelreachedgame = ViewBag.levelreached, n1 = ViewBag.awlchampn1, n2 = ViewBag.awlchampn2, n3 = ViewBag.awlchampn3, b = ViewBag.awlchampb })%>"><img alt="Play2" class="bonneimage" src="../../Images/button_play_2.png" /></a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsSection" runat="server">
</asp:Content>