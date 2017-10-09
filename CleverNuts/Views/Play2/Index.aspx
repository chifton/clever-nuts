<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Clever Nuts Awale
</asp:Content>

<asp:Content ID="indexFeatured" ContentPlaceHolderID="FeaturedContent" runat="server">
        <section class="featured">
    </section>
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
                <script type="text/javascript" src="../Scripts/jquery-1.8.2.min.js"></script>
                <script type="text/javascript" src="../Scripts/soundmanager2.js"></script>
                <script type="text/javascript" src="../Scripts/jquery.transit.min.js"></script>
                <script src="../../Scripts/jquery.blockUI.js"></script>
                <link type="text/css" href="../../Content/form.css" rel="stylesheet" />
                <script type="text/javascript" src="../Scripts/custom-form-elements.js"></script>
                
                <script type="text/javascript">

                document.addEventListener("DOMContentLoaded", function () {

                    window.history.pushState("object or string", "Title", "/savesquirrels");

                    // Récupération de tous les contrôles de la view
                    var ecranFullOk = false;
                    var blockGame = document.querySelector("#blockGame");
                    var pleinecran = document.querySelector(".imagescreen");
                    var ecranjeu = document.querySelector("#jeu");
                    var images = document.querySelectorAll(".bonneimage");
                    var image = document.querySelectorAll(".bonneimage2");
                    for (var t = 0; t < images.length; t++) {
                        $(".bonneimage").eq(t).hover(function () {
                            $(this).animate({ width: 400 }, 1, "linear");
                        }, function () {
                            $(this).animate({ width: 274 }, 1, "linear");
                        });
                    }
                    $(".bonneimage2").hover(function () {
                        $(this).animate({ width: 400 }, 1, "linear");
                    }, function () { $(this).animate({ width: 290 }, 1, "linear"); });

                    // Déblocage de la fenêtre dès le début
                    document.getElementById('imagechargement').style.display = 'none';
                    $("body").unblock();

                    // Mise en place de l'environnement de départ
                    var hibouMort = true;
                    var nbNuts = $('input#awlchampn3').val(); // Noix simples
                    var nbNutsBronze = $('input#awlchampn2').val(); // Noix en bronze
                    var nbNutsOr = $('input#awlchampn1').val(); // Noix en or
                    var nutsBonus = $('input#awlchampb').val();
                    var debuttop = 268;
                    var agitation = $('input#awlchamp3').val();
                    var nbniveaux = $('input#awlchamp').val();
                    var nbennemis = nbniveaux;
                    var nbamis = nbniveaux;
                    var topalea;
                    var leftalea;
                    $("#scoreOr").text(nbNutsOr.toString());
                    $("#scoreBronze").text(nbNutsBronze.toString());
                    $("#scoreSimple").text(nbNuts.toString());
                    $("#scoreBonus").text(nutsBonus.toString());
                    for (var o = 1; o <= nbniveaux; o++) {
                        // Création hibou
                        var hibou = $("<img alt='hibou' class='hiboucool' src='../../Images/hiboucool.png' />");
                        // var hibou = $("<div id='twiz-owl-main'><div name='twiz-flying-owl'><img src='../../Images/twiz-owl-b.png' alt='' title='' width='300' height='293' id='twiz-owl-b'/><img src='../../Images/twiz-owl-eyes.png' alt='' title='' width='80' height='38' id='twiz-owl-eyes'/><img src='../../Images/twiz-owl-l-w-s.png' alt='' title='' width='45' height='49' id='twiz-owl-l-w-s'/><img src='../../Images/twiz-owl-r-w-s.png' alt='' title='' width='45' height='49' id='twiz-owl-r-w-s'/><img src='../../Images/twiz-owl-l-w-b.png' alt='' title='' width='77' height='139' name='twiz-owl-l-w-b'/><img src='../../Images/twiz-owl-r-w-b.png' alt='' title='' width='77' height='139' name='twiz-owl-r-w-b'/><img src='../../Images/twiz-owl-r-f.png' alt='' width='58' height='39' id='twiz-owl-r-f'/><img src='../../Images/twiz-owl-l-f.png' alt='' width='58' height='38' id='twiz-owl-l-f'/></div></div>");
                        $("#jeu").append(hibou);
                        leftalea = aleatoire(570);
                        topalea = aleatoire($('input#awlchamp2').val());
                        var topalea2 = topalea;
                        hibou.css({ left: leftalea + "px", top: topalea + "px", animation: "bouge " + agitation + "ms ease-in infinite", mozAnimation: "bouge " + agitation + "ms ease-in infinite", oAnimation: "bouge " + agitation + "ms ease-in infinite", webkitAnimation: "bouge " + agitation + "ms ease-in infinite" });
                        var hibouquotient = (20000 * (350-parseInt(hibou.css("top").substring(0, parseInt(hibou.css('top').length - 2)))))/ 350;
                        hibou.animate({ "top": "225px" }, hibouquotient, "swing");

                        // Création écureuil
                        var ecureuil = $("<img alt='ecureuil' class='ecureuilcool' src='../../Images/ecureuilcool.png' />");
                        $("#jeu").append(ecureuil);
                        ecureuil.css({ left: leftalea + "px", top: "268px" });
                    }

                    // Catapulte de début
                    if (nbNuts != 0) {
                        $("#catapulte").attr("src", "../../Images/lanceboule.png");
                    }

                    // Gestion du choix du catapulteur Or, Bronze ou Simple
                        $('#radioOr').click(function () {
                            if ($(this).is(':checked')) {
                                if (nbNutsOr != 0) {
                                    $("#catapulte").attr("src", "../../Images/lancebouleOr.png");
                                }
                                else {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                            }
                        });
                        $('#radioBronze').click(function () {
                            if ($(this).is(':checked')) {
                                if (nbNutsBronze != 0)
                                {
                                    $("#catapulte").attr("src", "../../Images/lancebouleBronze.png");
                                }
                                else
                                {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                            }
                        });
                        $('#radioSimple').click(function () {
                            if ($(this).is(':checked')) {
                                if (nbNuts != 0)
                                {
                                    $("#catapulte").attr("src", "../../Images/lanceboule.png");
                                }
                                else
                                {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                            }
                        });

                    // Gestion des collisions hibou / écureuil et suppressions du hibou et de l'écureuil
                    setInterval(function(){
                        for (var u = 0; u <= ecranjeu.childElementCount - 1; u++) {
                            var monelement3;
                            monelement3 = $("#jeu").children().eq(u);
                            if (monelement3.attr("class") == "hiboucool") {
                                if (parseInt(monelement3.css("top").substring(0, parseInt(monelement3.css('top').length - 2))) >= 225) {
                                    for (var z = 0; z <= ecranjeu.childElementCount - 1; z++) {
                                        var monelement4;
                                        monelement4 = $("#jeu").children().eq(z);
                                        if (monelement4.attr("class") == "ecureuilcool") {
                                            var left1cool = parseInt(monelement4.css("left").substring(0, parseInt(monelement4.css('left').length - 2)));
                                            var left2cool = parseInt(monelement3.css("left").substring(0, parseInt(monelement3.css('left').length - 2)));
                                            if (left1cool == left2cool) {
                                                monelement4.remove();
                                            }
                                        }
                                    }
                                    var leftexplod = parseInt(monelement3.css("left").substring(0, parseInt(monelement3.css('left').length - 2)));
                                    var topexplod = parseInt(monelement3.css("top").substring(0, parseInt(monelement3.css('top').length - 2))) + 40;
                                    monelement3.remove();
                                    // Image d'explosion
                                    var explosion4 = $('<img id="explosion2">');
                                    explosion4.attr('src', '../../Images/explosion2.png');
                                    $("#jeu").append(explosion4);
                                    explosion4.css({ position: "absolute", left: leftexplod + "px", top: topexplod + "px" }).fadeOut(2000);
                                    
                                    // Son d'explosion
                                    // Fonction pour jouer le son
                                    soundManager.url = 'swf/';
                                    soundManager.onready(function () {
                                        // first, make the sound
                                        soundManager.createSound({
                                            id: 'sonBoule',
                                            url: '/Sounds/explod.mp3',
                                            autoplay: true,
                                            autoload: true,
                                            volume: 70
                                        });
                                    });
                                    soundManager.load('sonBoule', {
                                        onload: function () {
                                            this.play();
                                        }
                                    });
                                }
                            }
                        }
                    }, 2000);


                    // Gestion des bruitages
                    // Fonction pour jouer le son
                    soundManager.url = 'swf/';
                    soundManager.onready(function () {
                        soundManager.createSound({
                            id: 'sonHibou',
                            url: '/Sounds/hibou.mp3',
                            autoplay: true,
                            autoload: true,
                            loops: 1000000000000000,
                            volume:60
                        });
                        soundManager.createSound({
                            id: 'sonEcureuil',
                            url: '/Sounds/ecureuil.mp3',
                            autoplay: true,
                            autoload: true,
                            loops: 1000000000000000,
                            volume: 60
                        });
                        soundManager.createSound({
                            id: 'sonVent',
                            url: '/Sounds/vent.mp3',
                            autoplay: true,
                            autoload: true,
                            loops: 1000000000000000,
                            volume: 100
                        });
                    });
                    soundManager.load('sonHibou', {
                        onload: function () {
                            this.play();
                        }
                    });
                    soundManager.load('sonEcureuil', {
                        onload: function () {
                            this.play();
                        }
                    });
                    soundManager.load('sonVent', {
                        onload: function () {
                            this.play();
                        }
                    });

                    // Gestion du plein écran du jeu
                    /*pleinecran.addEventListener("click", function (e2) {
                        if (ecranFullOk == true) {
                            blockGame.insertBefore(ecranjeu, blockGame.firstChild);
                            ecranjeu.style.backgroundImage = "url('../Images/sky1.png')";
                            ecranjeu.style.margin = "auto";
                            ecranjeu.style.width = "600px";
                            ecranjeu.style.height = "350px";
                            ecranjeu.style.borderRadius = "15px";
                            ecranjeu.style.boxShadow = "0px 0px 10px 4px rgba(119, 119, 119, 0.76) inset";
                            ecranjeu.style.mozBoxShadow = "0px 0px 10px 4px rgba(119, 119, 119, 0.76) inset";
                            ecranjeu.style.webkitBoxShadow = "0px 0px 10px 4px rgba(119, 119, 119, 0.76) inset";
                            ecranjeu.style.background = "#007fd5";
                            ecranjeu.style.position = "relative";
                            ecranjeu.style.overflow = "hidden";
                            ecranjeu.style.webkitAnimation = "sky_background 50s ease-out infinite";
                            ecranjeu.style.mozAnimation = "sky_background 50s ease-out infinite";
                            ecranjeu.style.oAnimation = "sky_background 50s ease-out infinite";
                            ecranjeu.style.webkitTransform = "translate3d(0,0,0)";
                            ecranjeu.style.mozTransform = "translate3d(0,0,0)";
                            ecranjeu.style.oTransform = "translate3d(0,0,0)";
                            ecranjeu.style.border = "none";
                            ecranjeu.style.cursor = "url('../Images/croix.png'), default";
                            ecranjeu.appendChild(pleinecran);
                            pleinecran.style.position = "absolute";
                            pleinecran.style.bottom = "0px";
                            pleinecran.style.right = "0px";
                            pleinecran.style.textAlign = "right";
                            pleinecran.style.cursor = "pointer";


                            var ratio = screen.width / 600;
                            //Redimensionne et positionne tous les éléments en plein écran
                            for (var u = 0; u <= ecranjeu.childElementCount - 1; u++) {
                                var monelement = $("#jeu").children().eq(u);
                                var coord1 = parseInt(monelement.css("left").substring(0, parseInt(monelement.css('left').length - 2))) / ratio;
                                var coord2 = parseInt(monelement.css("top").substring(0, parseInt(monelement.css('top').length - 2))) / ratio;
                                var coord3 = parseInt(monelement.css("width").substring(0, parseInt(monelement.css('width').length - 2))) / ratio;
                                var coord4 = parseInt(monelement.css("height").substring(0, parseInt(monelement.css('height').length - 2))) / ratio;
                                monelement.css({ left: coord1.toString(), top: coord2.toString(), width: coord3.toString(), height: coord4.toString() });
                            }
                            ecranFullOk = false;
                        }
                        else {
                            document.body.appendChild(ecranjeu);
                            ecranjeu.style.position = "absolute";
                            ecranjeu.style.top = "0px";
                            ecranjeu.style.left = "0px";
                            ecranjeu.style.height = "160%";
                            ecranjeu.style.width = "100%";

                            var ratio = screen.width / 600;
                            //Redimensionne et positionne tous les éléments en plein écran
                            for (var u = 0; u <= ecranjeu.childElementCount - 1; u++)
                            {
                                var monelement = $("#jeu").children().eq(u);
                                var coord1 = parseInt(monelement.css("left").substring(0, parseInt(monelement.css('left').length - 2))) * ratio;
                                var coord2 = parseInt(monelement.css("top").substring(0, parseInt(monelement.css('top').length - 2))) * ratio;
                                var coord3 = parseInt(monelement.css("width").substring(0, parseInt(monelement.css('width').length - 2)))*ratio;
                                var coord4 = parseInt(monelement.css("height").substring(0, parseInt(monelement.css('height').length - 2)))*ratio;
                                monelement.css({ left: coord1.toString(), top: coord2.toString(), width: coord3.toString(), height: coord4.toString()});
                            }
                            ecranFullOk = true;
                        }
                        e2.stopPropagation();
                    });*/

                    // Gestion de la mise à feu du catapulteur
                    var catapultecool = document.querySelector("#catapulte");
                    ecranjeu.addEventListener("click", function (e) {

                        if (hibouMort == true) {

                            // Le hibou n'est pas encore mort, donc on ne peut pas lancer
                            // de nouvelles noix ou glands
                            hibouMort = false;
                            if ($("#radioSimple").is(":checked") && nbNuts > 0) {

                                nbNuts = nbNuts - 1;
                                $("#scoreOr").text(nbNutsOr.toString());
                                $("#scoreBronze").text(nbNutsBronze.toString());
                                $("#scoreSimple").text(nbNuts.toString());

                                // Pour changer le catapulteur au cas ou il n'y a plus de noix
                                // Mise à jour du catapulteur s'il n'y a plus de noix
                                if ($("#radioSimple").is(":checked") && nbNuts == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                                else if ($("#radioBronze").is(":checked") && nbNutsBronze == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                                else if ($("#radioOr").is(":checked") && nbNutsOr == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }

                                // Fonction pour jouer le son
                                soundManager.url = 'swf/';
                                soundManager.onready(function () {
                                    // first, make the sound
                                    soundManager.createSound({
                                        id: 'sonLance',
                                        url: '/Sounds/catapult.mp3',
                                        autoplay: true,
                                        autoload: true,
                                        volume: 80
                                    });
                                });
                                soundManager.load('sonLance', {
                                    onload: function () {
                                        this.play();
                                    }
                                });

                                // Explosion
                                var explosion = $('<img id="explosion2">');
                                explosion.attr('src', '../../Images/explosion2.png');
                                $("#jeu").append(explosion);
                                var positiones = parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2))) + 50;
                                explosion.css({ position: "absolute", margin: "auto", left: positiones.toString() + "px", bottom: "8px", "text-align": "center" }).fadeOut(2000);

                                // Déplacement du gland
                                // Coordonnées du gland
                                var ev = e || window.event;
                                var pos = findPos(this);
                                var diffx = ev.clientX - pos.x;
                                var diffy = ev.clientY - pos.y;
                                // Création du gland à lancer
                                var positiondebut = 50 + parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2)));
                                var noixgland = $("<img id='noixgland' style='position : absolute;bottom: 5px;left: " + positiondebut.toString() + "px;'>");
                                noixgland.attr('src', '../../Images/glandlance.png');
                                noixgland.appendTo(ecranjeu);
                                // Lancement du gland
                                var initial = 50 + parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2)));
                                var finleft = diffx - 6;
                                finleft = finleft + "px";
                                var fintop = 350 - diffy - 30;
                                fintop = fintop + "px";
                                noixgland.css({ left: finleft, bottom: fintop });

                                // Gestion de la gagne
                                for (var u = 0; u <= ecranjeu.childElementCount - 1; u++) {
                                    var monelement2;
                                    monelement2 = $("#jeu").children().eq(u);
                                    if (monelement2.attr("class") == "hiboucool") {
                                        var lefthibou = parseInt(monelement2.css("left").substring(0, parseInt(monelement2.css('left').length - 2)));
                                        var tophibou = parseInt(monelement2.css("top").substring(0, parseInt(monelement2.css('top').length - 2)));
                                        if ((diffx > lefthibou && diffx < lefthibou + 30) && (diffy < tophibou + 30)) {
                                            setTimeout(function (hibouelement, noixelement) {
                                                var explosionhibou = $('<img id="explosion2">');
                                                explosionhibou.attr('src', '../../Images/explosion2.png');
                                                $("#jeu").append(explosionhibou);
                                                var positioneshibou1 = diffx - 5;
                                                var positioneshibou2 = diffy - 5;
                                                // Suppression du hibou et de la noix
                                                hibouelement.remove();
                                                noixelement.remove();
                                                // Mise à jour du bonus
                                                nutsBonus = parseInt(nutsBonus) + 10;
                                                $("#scoreBonus").text(parseInt(nutsBonus).toString());
                                                // Mort du hibou en son
                                                soundManager.url = 'swf/';
                                                soundManager.onready(function () {
                                                    // first, make the sound
                                                    soundManager.createSound({
                                                        id: 'sonHibouDead',
                                                        url: '/Sounds/hiboudeath.mp3',
                                                        autoplay: true,
                                                        autoload: true,
                                                        volume: 100
                                                    });
                                                });
                                                soundManager.load('sonHibouDead', {
                                                    onload: function () {
                                                        this.play();
                                                    }
                                                });
                                                // Fonction pour jouer le son
                                                soundManager.url = 'swf/';
                                                soundManager.onready(function () {
                                                    // first, make the sound
                                                    soundManager.createSound({
                                                        id: 'sonBoule',
                                                        url: '/Sounds/explod.mp3',
                                                        autoplay: true,
                                                        autoload: true,
                                                        volume: 80
                                                    });
                                                });
                                                soundManager.load('sonBoule', {
                                                    onload: function () {
                                                        this.play();
                                                    }
                                                });
                                                explosionhibou.css({ position: "absolute", left: positioneshibou1 + "px", top: positioneshibou2 + "px" }).fadeOut(1000);
                                                hibouMort = true;
                                            }, 1050, monelement2, noixgland); // Pour les 1 secondes de transition CSS
                                        }
                                        else {
                                            setTimeout(function (noixelement) {
                                                noixelement.remove();
                                                hibouMort = true;
                                            }, 1050, noixgland);
                                        }
                                    }
                                }
                            }
                            else if ($("#radioBronze").is(":checked") && nbNutsBronze > 0) {

                                nbNutsBronze = nbNutsBronze - 1;
                                $("#scoreOr").text(nbNutsOr.toString());
                                $("#scoreBronze").text(nbNutsBronze.toString());
                                $("#scoreSimple").text(nbNuts.toString());

                                // Pour changer le catapulteur au cas ou il n'y a plus de noix
                                // Mise à jour du catapulteur s'il n'y a plus de noix
                                if ($("#radioSimple").is(":checked") && nbNuts == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                                else if ($("#radioBronze").is(":checked") && nbNutsBronze == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                                else if ($("#radioOr").is(":checked") && nbNutsOr == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }

                                // Fonction pour jouer le son
                                soundManager.url = 'swf/';
                                soundManager.onready(function () {
                                    // first, make the sound
                                    soundManager.createSound({
                                        id: 'sonBoule2',
                                        url: '/Sounds/explod3.mp3',
                                        autoplay: true,
                                        autoload: true,
                                        volume: 70
                                    });
                                });
                                soundManager.load('sonBoule2', {
                                    onload: function () {
                                        this.play();
                                    }
                                });

                                // Explosion
                                var explosion = $('<img id="explosion2">');
                                explosion.attr('src', '../../Images/explosion2.png');
                                $("#jeu").append(explosion);
                                var positiones = parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2))) + 50;
                                explosion.css({ position: "absolute", margin: "auto", left: positiones.toString() + "px", bottom: "8px", "text-align": "center" }).fadeOut(2000);

                                // Déplacement du gland
                                // Coordonnées du gland
                                var ev = e || window.event;
                                var pos = findPos(this);
                                var diffx = ev.clientX - pos.x;
                                var diffy = ev.clientY - pos.y;
                                // Création du gland à lancer
                                var positiondebut = 50 + parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2)));
                                var noixgland = $("<img id='noixgland' style='position : absolute;bottom: 5px;left: " + positiondebut.toString() + "px;'>");
                                noixgland.attr('src', '../../Images/glandlancebronze.png');
                                noixgland.appendTo(ecranjeu);
                                // Lancement du gland
                                var initial = 50 + parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2)));
                                var finleft = diffx - 6;
                                finleft = finleft + "px";
                                var fintop = 350 - diffy - 30;
                                fintop = fintop + "px";
                                noixgland.css({ left: finleft, bottom: fintop });

                                // Gestion de la gagne
                                for (var u = 0; u <= ecranjeu.childElementCount - 1; u++) {
                                    var monelement2;
                                    monelement2 = $("#jeu").children().eq(u);
                                    if (monelement2.attr("class") == "hiboucool") {
                                        var lefthibou = parseInt(monelement2.css("left").substring(0, parseInt(monelement2.css('left').length - 2)));
                                        var tophibou = parseInt(monelement2.css("top").substring(0, parseInt(monelement2.css('top').length - 2)));
                                        if ((diffy - 40) < tophibou && tophibou < (diffy + 40)) {
                                            setTimeout(function (hibouelement, noixelement) {
                                                var explosionhibou = $('<img id="explosion2">');
                                                explosionhibou.attr('src', '../../Images/explosion2.png');
                                                $("#jeu").append(explosionhibou);
                                                var positioneshibou1 = diffx - 5;
                                                var positioneshibou2 = diffy - 5;
                                                // Mur de bronze
                                                var murbronze = $('<div id="murBronze"></div>');
                                                $("#jeu").append(murbronze);
                                                murbronze.css({ position: "absolute", left: "0px", width: "600px", height: "80px", top: parseInt(diffy - 25) + "px" }).fadeOut(2000);
                                                // Suppression du hibou et de la noix
                                                hibouelement.remove();
                                                // Si la noix de bronze existe, on la supprime
                                                if (noixelement) {
                                                    noixelement.remove();
                                                }
                                                // Mise à jour du bonus
                                                nutsBonus = parseInt(nutsBonus) + 100;
                                                $("#scoreBonus").text(parseInt(nutsBonus).toString());
                                                // Mort du hibou en son
                                                soundManager.url = 'swf/';
                                                soundManager.onready(function () {
                                                    // first, make the sound
                                                    soundManager.createSound({
                                                        id: 'sonHibouDead',
                                                        url: '/Sounds/hiboudeath.mp3',
                                                        autoplay: true,
                                                        autoload: true,
                                                        volume: 100
                                                    });
                                                });
                                                soundManager.load('sonHibouDead', {
                                                    onload: function () {
                                                        this.play();
                                                    }
                                                });
                                                explosionhibou.css({ position: "absolute", left: positioneshibou1 + "px", top: positioneshibou2 + "px" }).fadeOut(2000);
                                                hibouMort = true;
                                            }, 1050, monelement2, noixgland); // Pour les 1 secondes de transition CSS
                                            // On supprime le gland de bronze à la fin du spectacle
                                        }
                                        else {
                                            // Pour les hibous qui ne sont pas dans le champ de destruction
                                            // On peut profiter pour supprimer le gland qu'on arrive pas à supprimer
                                            // On supprime le gland de bronze à la fin du spectacle s'il ne l'est pas
                                            var positioneshibou1 = diffx - 5;
                                            var positioneshibou2 = diffy - 5;
                                            var explosionhibou = $('<img id="explosion2">');
                                            explosionhibou.attr('src', '../../Images/explosion2.png');
                                            if (noixgland) {
                                                setTimeout(function () {
                                                    $("#jeu").append(explosionhibou);
                                                    explosionhibou.css({ position: "absolute", left: positioneshibou1 + "px", top: positioneshibou2 + "px" }).fadeOut(2000);
                                                    noixgland.remove();
                                                    hibouMort = true;
                                                }, 1000);
                                            }
                                        }
                                    }
                                }
                            }
                            else if ($("#radioOr").is(":checked") && nbNutsOr > 0) {

                                nbNutsOr = nbNutsOr - 1;
                                $("#scoreOr").text(nbNutsOr.toString());
                                $("#scoreBronze").text(nbNutsBronze.toString());
                                $("#scoreSimple").text(nbNuts.toString());

                                // Pour changer le catapulteur au cas ou il n'y a plus de noix
                                // Mise à jour du catapulteur s'il n'y a plus de noix
                                if ($("#radioSimple").is(":checked") && nbNuts == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                                else if ($("#radioBronze").is(":checked") && nbNutsBronze == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }
                                else if ($("#radioOr").is(":checked") && nbNutsOr == 0) {
                                    $("#catapulte").attr("src", "../../Images/lance.png");
                                }

                                // Fonction pour jouer le son
                                soundManager.url = 'swf/';
                                soundManager.onready(function () {
                                    // first, make the sound
                                    soundManager.createSound({
                                        id: 'sonBoule3',
                                        url: '/Sounds/explod4.mp3',
                                        autoplay: true,
                                        autoload: true,
                                        volume: 70
                                    });
                                });
                                soundManager.load('sonBoule3', {
                                    onload: function () {
                                        this.play();
                                    }
                                });

                                // Explosion
                                var explosion = $('<img id="explosion2">');
                                explosion.attr('src', '../../Images/explosion2.png');
                                $("#jeu").append(explosion);
                                var positiones = parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2))) + 50;
                                explosion.css({ position: "absolute", margin: "auto", left: positiones.toString() + "px", bottom: "8px", "text-align": "center" }).fadeOut(2000);

                                // Déplacement du gland
                                // Coordonnées du gland
                                var ev = e || window.event;
                                var pos = findPos(this);
                                var diffx = ev.clientX - pos.x;
                                var diffy = ev.clientY - pos.y;
                                // Création du gland à lancer
                                var positiondebut = 50 + parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2)));
                                var noixgland = $("<img id='noixgland' style='position : absolute;bottom: 5px;left: " + positiondebut.toString() + "px;'>");
                                noixgland.attr('src', '../../Images/glandlanceor.png');
                                noixgland.appendTo(ecranjeu);
                                // Lancement du gland
                                var initial = 50 + parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2)));
                                var finleft = diffx - 6;
                                finleft = finleft + "px";
                                var fintop = 350 - diffy - 30;
                                fintop = fintop + "px";
                                noixgland.css({ left: finleft, bottom: fintop });

                                // Gestion de la gagne
                                for (var u = 0; u <= ecranjeu.childElementCount - 1; u++) {
                                    var monelement2;
                                    monelement2 = $("#jeu").children().eq(u);
                                    if (monelement2.attr("class") == "hiboucool") {
                                        var lefthibou = parseInt(monelement2.css("left").substring(0, parseInt(monelement2.css('left').length - 2)));
                                        var tophibou = parseInt(monelement2.css("top").substring(0, parseInt(monelement2.css('top').length - 2)));
                                        // if ((diffy - 40) < tophibou && tophibou < (diffy + 40)) {
                                        setTimeout(function (hibouelement, noixelement) {
                                            var explosionhibou = $('<img id="explosion2">');
                                            explosionhibou.attr('src', '../../Images/explosion2.png');
                                            $("#jeu").append(explosionhibou);
                                            var positioneshibou1 = diffx - 5;
                                            var positioneshibou2 = diffy - 5;
                                            // Mur d'OR
                                            var murOr = $('<div id="murGold"></div>');
                                            $("#jeu").append(murOr);
                                            murOr.css({ position: "absolute", left: "0px", width: "600px", height: "350px", top: "0px" }).fadeOut(2500);
                                            // Suppression du hibou et de la noix
                                            hibouelement.remove();
                                            // Si la noix d'or existe, on la supprime
                                            if (noixelement) {
                                                noixelement.remove();
                                            }
                                            // Mise à jour du bonus
                                            nutsBonus = parseInt(nutsBonus) + 1000;
                                            $("#scoreBonus").text(parseInt(nutsBonus).toString());
                                            // Mort du hibou en son
                                            soundManager.url = 'swf/';
                                            soundManager.onready(function () {
                                                // first, make the sound
                                                soundManager.createSound({
                                                    id: 'sonHibouDead',
                                                    url: '/Sounds/hiboudeath.mp3',
                                                    autoplay: true,
                                                    autoload: true,
                                                    volume: 100
                                                });
                                            });
                                            soundManager.load('sonHibouDead', {
                                                onload: function () {
                                                    this.play();
                                                }
                                            });
                                            explosionhibou.css({ position: "absolute", left: positioneshibou1 + "px", top: positioneshibou2 + "px" }).fadeOut(2000);
                                            hibouMort = true;
                                        }, 1050, monelement2, noixgland); // Pour les 1 secondes de transition CSS
                                        // On supprime le gland de bronze à la fin du spectacle
                                        //}

                                    }
                                }
                            }
                            else {
                                // Gérer peut être s'il n'y a pas de noix
                            }
                        }
                    });

                    // Test de fin de jeu
                    var myVar = setInterval(function (niveaulevel, niveautop) {
                        var nbHibous = 0;
                        var nbEcureuils = 0;
                        for (var w = 0; w <= ecranjeu.childElementCount - 1; w++) {
                            var monelementHibouEcureuil;
                            monelementHibouEcureuil = $("#jeu").children().eq(w);
                            if (monelementHibouEcureuil.attr("class") == "hiboucool") {
                                nbHibous = nbHibous + 1;
                            }
                            else if(monelementHibouEcureuil.attr("class") == "ecureuilcool") {
                                nbEcureuils = nbEcureuils + 1;
                            }
                        }
                        // Confirmation pour jouer ou continuer
                        if (nbEcureuils == 0){
                            var reponsejeu = jConfirm("You lost ! Replay ?", 'Finished Level !', function(r) {
                                if (r) {
                                    clearInterval(myVar);
                                    var urlcool = "/Play2/truelevel";
                                    var urlcoolendlast = "/Play2/gameend";
                                    $.get(urlcool, { ntruelevel: $('input#haha').val() }, function (datalevel3) {
                                        $.get(urlcoolendlast, { n1: nbNutsOr, n2: nbNutsBronze, n3: nbNuts, b: nutsBonus, good: parseInt($('input#haha').val()) }, function (retourdata) {
                                                    while (nbNuts > 30) {
                                                        var restesimple = nbNuts - 30;
                                                        nbNutsBronze = nbNutsBronze + 1;
                                                        nbNuts = restesimple;
                                                    }
                                                    while (nbNutsBronze > 10) {
                                                        var restesimple2 = nbNutsBronze - 10;
                                                        nbNutsOr = nbNutsOr + 1;
                                                        nbNutsBronze = restesimple2;
                                                    }
                                                    location.href = encodeURI("/Play2/Index?levelreachedgame=" + encodeURIComponent(datalevel3) + "&n1=" + encodeURIComponent(parseInt(nbNutsOr)) + "&n2=" + encodeURIComponent(parseInt(nbNutsBronze)) + "&n3=" + encodeURIComponent(parseInt(nbNuts)) + "&b=" + encodeURIComponent(parseInt(nutsBonus)));
                                                });
                                            });
                                }
                                else {
                                    clearInterval(myVar);
                                    var urlindex = "/Home/Index";
                                    var urlcoolendlast = "/Play2/gameend";
                                    $.get(urlcoolendlast, { n1: nbNutsOr, n2: nbNutsBronze, n3: nbNuts, b: nutsBonus, good: parseInt($('input#haha').val()) }, function (retourdata) {
                                        $.get(urlindex, null, function () {
                                        location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                        });
                                    });
                                }
                            });
                        }
                        else if(nbHibous == 0) {
                            var reponsejeu = jConfirm("You won ! Play next level ?", 'Finished Level !', function (r) {
                                if (r) {
                                    clearInterval(myVar);
                                    var urlcool = "/Play2/truelevel";
                                    var urlcoolendlast = "/Play2/gameend";
                                    $.get(urlcool, { ntruelevel: parseInt($('input#haha').val()) + 1 }, function (datalevel3) {
                                        $.get(urlcoolendlast, { n1: nbNutsOr, n2: nbNutsBronze, n3: parseInt(nbNuts) + 2, b: nutsBonus, good: parseInt($('input#haha').val()) }, function (retourdata) {
                                                while (nbNuts > 30) {
                                                    var restesimple = nbNuts - 30;
                                                    nbNutsBronze = nbNutsBronze + 1;
                                                    nbNuts = restesimple;
                                                }
                                                while (nbNutsBronze > 10) {
                                                    var restesimple2 = nbNutsBronze - 10;
                                                    nbNutsOr = nbNutsOr + 1;
                                                    nbNutsBronze = restesimple2;
                                                }
                                                location.href = encodeURI("/Play2/Index?levelreachedgame=" + encodeURIComponent(datalevel3) + "&n1=" + encodeURIComponent(parseInt(nbNutsOr)) + "&n2=" + encodeURIComponent(parseInt(nbNutsBronze)) + "&n3=" + encodeURIComponent(parseInt(parseInt(nbNuts) + 2)) + "&b=" + encodeURIComponent(parseInt(nutsBonus)));
                                            });
                                        });
                                }
                                else {
                                    clearInterval(myVar);
                                    var urlcoolendlast = "/Play2/gameend";
                                    $.get(urlcoolendlast, { n1: nbNutsOr, n2: nbNutsBronze, n3: nbNuts, b: nutsBonus, good: parseInt($('input#haha').val()) }, function (retourdata) {
                                        location.href = '<%= Page.ResolveUrl("~/Home/Index") %>';
                                    });
                                }
                            });
                        }
                        else if (nbNuts == 0 && nbNutsOr == 0 && nbNutsBronze == 0) {
                            clearInterval(myVar);
                            var urlcoolendlast = "/Play2/gameend";
                            $.get(urlcoolendlast, { n1: nbNutsOr, n2: nbNutsBronze, n3: nbNuts, b: nutsBonus, good: parseInt($('input#haha').val()) }, function (retourdata) {
                                var reponsejeulast = jAlert("You don't have nuts ! Buy them or win them playing awale !", 'No more nuts !', function (r) {
                                if (r) {
                                    location.href = '<%= Page.ResolveUrl("~/Management2/Index") %>';
                                }
                                });
                            });
                        }
                    }, 2000, nbniveaux, topalea);

                    // Gestion des déplacements du catapulteur
                    var positiones2;
                    document.addEventListener('keydown', function (e) {
                        if (e.keyCode == 37) {
                            positiones2 = parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2))) - 5;
                            if (positiones2 > -67){
                                $("#catapulte").css({ left: positiones2.toString() + "px" });
                            }
                        }
                        else if (e.keyCode == 39) {
                            positiones2 = parseInt($("#catapulte").css('left').substring(0, parseInt($("#catapulte").css('left').length - 2))) + 5;
                            if (positiones2 < 526) {
                                $("#catapulte").css({ left: positiones2.toString() + "px" });
                            }
                        }
                        /*else if (e.keyCode == 27) {
                            if (ecranFullOk == true) {
                                blockGame.insertBefore(ecranjeu, blockGame.firstChild);
                                ecranjeu.style.backgroundImage = "url('../Images/sky1.png')";
                                ecranjeu.style.margin = "auto";
                                ecranjeu.style.width = "600px";
                                ecranjeu.style.height = "350px";
                                ecranjeu.style.borderRadius = "15px";
                                ecranjeu.style.boxShadow = "0px 0px 10px 4px rgba(119, 119, 119, 0.76) inset";
                                ecranjeu.style.mozBoxShadow = "0px 0px 10px 4px rgba(119, 119, 119, 0.76) inset";
                                ecranjeu.style.webkitBoxShadow = "0px 0px 10px 4px rgba(119, 119, 119, 0.76) inset";
                                ecranjeu.style.background = "#007fd5";
                                ecranjeu.style.position = "relative";
                                ecranjeu.style.overflow = "hidden";
                                ecranjeu.style.webkitAnimation = "sky_background 50s ease-out infinite";
                                ecranjeu.style.mozAnimation = "sky_background 50s ease-out infinite";
                                ecranjeu.style.oAnimation = "sky_background 50s ease-out infinite";
                                ecranjeu.style.webkitTransform = "translate3d(0,0,0)";
                                ecranjeu.style.mozTransform = "translate3d(0,0,0)";
                                ecranjeu.style.oTransform = "translate3d(0,0,0)";
                                ecranjeu.style.border = "none";
                                ecranjeu.style.cursor = "url('../Images/croix.png'), default";
                                ecranjeu.appendChild(pleinecran);
                                pleinecran.style.position = "absolute";
                                pleinecran.style.bottom = "0px";
                                pleinecran.style.right = "0px";
                                pleinecran.style.textAlign = "right";
                                pleinecran.style.cursor = "pointer";
                                ecranFullOk = false;
                            }
                            e.stopPropagation();
                        }*/
                    }, false);
                    // Quand la souris se déplace
                    ecranjeu.addEventListener('mousemove', function (e2) {
                        var ev2 = e2 || window.event;
                        var pos2 = findPos(this);
                        var diffx2 = ev2.clientX - pos2.x - 58;
                        var diffy2 = ev2.clientY - pos2.y;
                        $("#catapulte").css({ left: diffx2 + "px" });
                    });

                    function findPos(el) {
                        var x = y = 0;
                        if (el.offsetParent) {
                            x = el.offsetLeft;
                            y = el.offsetTop;
                            while (el = el.offsetParent) {
                                x += el.offsetLeft;
                                y += el.offsetTop;
                            }
                        }
                        return { 'x': x, 'y': y };
                    }

                    function aleatoire(N) {
                        return (Math.floor((N) * Math.random() + 1));
                    }

                });
                </script>


        <div id="blockGame">
            <div id="block1">
        <div id="jeu">
    
        <div class="clouds_one"></div>

        <div class="clouds_two"></div>

        <div class="clouds_three"></div>

        <img alt="Grass" id="grass" class="grass" src="../../Images/fondsol.png" />
        <img alt="Catapulte" id="catapulte" class="catapulte" src="../../Images/lance.png" />
        <!-- <img alt="FullScreen" class="imagescreen" src="../../Images/fullscreen.png" /> -->
        </div>

            <div id="consoleawl2">
                <form id="formulaireNuts">
                <div id="nutsOr">
                    <input type="radio" id="radioOr" name="radioNuts">
                    <img alt="Or" id="nutsOrimg" src="../../Images/gold.png" />
                    <span id="scoreOr"></span>
                </div>
                <div id="nutsBronze">
                    <input type="radio" id="radioBronze" name="radioNuts">
                    <img alt="Bronze" id="nutsBronzeimg" src="../../Images/bronze.png" />
                    <span id="scoreBronze"></span>
                </div>
                <div id="nutsSimple">
                    <input type="radio" id="radioSimple" name="radioNuts" checked>
                    <img alt="Simple" id="nutsSimpleimg" src="../../Images/simple.png" />
                    <span id="scoreSimple"></span>
                </div>
                <div id="nutsBonus">
                    <img alt="Bonus" id="nutsBonusimg" src="../../Images/bonus.png" /><br />
                    <span id="scoreBonus"></span>
                </div>
                </form>
            </div>
        </div>
        <div class="boutons3">
            <a class="boutondisparait" href="<%= Url.Action("Index", "Play") %>"><img alt="Play1" class="bonneimage" src="../../Images/button_play_1.png" /></a>
            <% if (Convert.ToString(ViewData["ici"]) == "site") {
                        %>
                    <a class="boutondisparait" href="<%= Url.Action("Manage", "Account") %>"><img alt="Buy1" class="bonneimage" src="../../Images/buynuts.png" /></a>
    <% } else if(Convert.ToString(ViewData["ici"]) == "facebook") { %>
            <a class="boutondisparait" href="<%= Url.Action("Manage", "FacebookNutter", new { identifiant = ViewBag.idfbk })%>"><img class="bonneimage2" title="Buy nuts with facebook !" src="<%= Url.Content("../../Images/buynuts.png") %>" /></a>
        <% } %>
        </div>
    </div>
    <input type="hidden" id="awlchamp" name="awlchamp" class="awlchamp" value="<%=  ViewBag.niveau %>" />
    <input type="hidden" id="awlchamp2" name="awlchamp2" class="awlchamp2" value="<%=  ViewBag.leveltop %>" />
    <input type="hidden" id="awlchamp3" name="awlchamp3" class="awlchamp3" value="<%=  ViewBag.agitation %>" />
    <input type="hidden" id="awlchampn1" name="awlchampn1" class="awlchampn1" value="<%=  ViewBag.n1 %>" />
    <input type="hidden" id="haha" name="haha" class="haha" value="<%=  ViewBag.haha %>" />
    <input type="hidden" id="awlchampn2" name="awlchampn2" class="awlchampn2" value="<%=  ViewBag.n2 %>" />
    <input type="hidden" id="awlchampn3" name="awlchampn3" class="awlchampn3" value="<%=  ViewBag.n3 %>" />
    <input type="hidden" id="awlchampb" name="awlchampb" class="awlchampb" value="<%=  ViewBag.b %>" />
</asp:Content>