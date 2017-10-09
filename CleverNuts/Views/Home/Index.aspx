<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="indexFeatured" ContentPlaceHolderID="FeaturedContent" runat="server">
    <section class="featured">

    </section>
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
            <script language="c#" runat="server">
            protected void Page_Load(object sender, EventArgs e)
                {
                /*
                        if (Convert.ToString(Page.Session["MediaPlay"]) == "")
                            {
                                this.Page.Response.Write("<object type='audio/mpeg' data='/Sounds/back.mp3' height='0' width='0'><param name='filename' value='/Sounds/back.mp3' /><param name='autostart' value='true' /><param name='loop' value='true' /><object>");
                                this.Page.Session["MediaPlay"] = "TRUE";
                            }
                 */
                }
            </script>
            
            <script src="../../Scripts/jquery-1.8.2.js"></script>
            <link href="../../Content/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
            <script src="../../Scripts/jquery-ui-1.8.24.min.js"></script>
            <script type="text/javascript" src="../../Scripts/jquery.youtubepopup.min.js"></script>
            <script src="../../Scripts/soundmanager2.js"></script>
            <script src="../../Scripts/jquery.blockUI.js"></script>
            <script src="https://www.youtube.com/iframe_api"></script>
            <script type="text/javascript">

                // Pour la gestion de la vidéo du jeu
                var player, playing = false;
                function onYouTubeIframeAPIReady() {
                    player = new YT.Player('video', {
                        height: '200',
                        width: '300',
                        videoId: '3mBtvFZCgGQ',
                        events: {
                            'onStateChange': onPlayerStateChange
                        }
                    });
                }
                
                function onPlayerStateChange(event) {
                    if (!playing) {
                        soundManager.muteAll();
                        playing = true;
                        document.getElementById("imagevolume").style.borderColor = "red";
                    }
                    else
                    {
                        soundManager.unmuteAll();
                        playing = false;
                        document.getElementById("imagevolume").style.borderColor = "green";
                    }
                }

                document.addEventListener("DOMContentLoaded", function () {

                    // Dimensionnement des images
                    var images = document.querySelectorAll(".bonneimage");
                    var image;
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
                        }, function () { $(this).animate({ width: 274 }, 1, "linear"); });
                    }
                    
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
                                loops: 2,
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

                    // Apparition de l'éclair
                    /*var topEclair = aleatoire(screen.availHeight);
                    var leftEclair = aleatoire(screen.availWidth);
                    var eclairGud = $('<img id="Eclair">');
                    eclairGud.attr('src', '../../Images/eclair.png');
                    $("body").append(eclairGud);
                    eclairGud.css({ position: "absolute", left: leftEclair + "px", top: topEclair + "px" }).fadeOut(1500);
                    // Son de l'éclair
                    soundManager.onready(function () {
                        soundManager.createSound({
                           id: 'sonOrage',
                            url: '/Sounds/orage.mp3',
                            autoplay: true,
                            autoload: true,
                            loops: 1,
                            volume: 70
                        });
                    });
                    soundManager.load('sonOrage', {
                        onload: function () {
                            this.play();
                        }
                    });
                    setTimeout(function () {
                        eclairGud.remove();
                    }, 1500);
                    setInterval(function () {
                        var topEclair = aleatoire(screen.availHeight);
                        var leftEclair = aleatoire(screen.availWidth);
                        var eclairGud = $('<img id="Eclair">');
                        eclairGud.attr('src', '../../Images/eclair.png');
                        $("body").append(eclairGud);
                        eclairGud.css({ position: "absolute", left: leftEclair + "px", top: topEclair + "px" }).fadeOut(1500);
                        // Son de l'éclair
                        soundManager.onready(function () {
                            soundManager.createSound({
                                id: 'sonOrage',
                                url: '/Sounds/orage.mp3',
                                autoplay: true,
                                autoload: true,
                                loops: 1,
                                volume: 70
                            });
                        });
                        soundManager.load('sonOrage', {
                            onload: function () {
                                this.play();
                            }
                        });
                        setTimeout(function () {
                            eclairGud.remove();
                        }, 1500);
                    }, 30000);*/

                    // Trainée de poudre derrière
                    $(document).mousemove(function (e) {
                        var image = $('<img id="traine">');
                        image.attr('src', '../../Images/trainee.png');
                        image.appendTo(document.body);
                        image.css({ "position":"absolute",top: e.pageY +2 ,left: e.pageX +2}).fadeOut(1200);
                    });

                    // Fonction de génération aléatoire
                    function aleatoire(N) {
                        return (Math.floor((N) * Math.random() + 1));
                    }

                });
                </script>
                            
    <div class="float-center">
         <div class="boutons1"> 
        <div id="video"></div>
         </div>
        <div class="boutons2">
            <a class="boutondisparait" href="<%= Url.Action("Index", "Management")%>"><img class ="bonneimage" src="<%= Url.Content("../../Images/button_play.png") %>" /></a>
            <a class="boutondisparait" href="<%= Url.Action("Index", "Rules") %>"><img class="bonneimage" src="../../Images/button_rules.png" /></a>
        </div>
    </div>
</asp:Content>