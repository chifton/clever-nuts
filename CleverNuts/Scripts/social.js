var friendCache = {};

function login(callback) {
    FB.login(callback, { scope: 'user_friends' });
}
function loginCallback(response) {
    console.log('loginCallback', response);
    if (response.status != 'connected') {
        top.location.href = 'https://www.facebook.com/appcenter/clevernuts';
    }
}
function onStatusChange(response) {
    if (response.status != 'connected') {
        login(loginCallback);
    } else {
        getMe(function () {
            // Code pour aller vers un controlleur de création de compte
            var urlfacebook = "/FacebookNutter/RegisterFbk";
            var urlrealfacebook = "/ApplicationReal/RegisterAllFbk";
            $.get(urlfacebook, { idfk: friendCache.me.id, usernamefk: friendCache.me.first_name, emailfk: friendCache.me.email }, function (datafacebook) {
                if(datafacebook == "OKRA")
                {
                    console.log(datafacebook);
                    // Code pour aller vers un controlleur pour affichage du compte
                    renderWelcome(friendCache.me.id, friendCache.me.first_name);
                }
                else if(datafacebook == "KO")
                {
                    // Code pour aller vers un controlleur pour affichage du compte
                    renderWelcome(friendCache.me.id, friendCache.me.first_name);
                    console.log(datafacebook);
                }
                else if (datafacebook == "KOA")
                {
                    console.log(datafacebook);
                }
            });
            // On envoie l'id facebook à toutes les pages qui hériteront de ApplicationRealController
            $.get(urlrealfacebook, { idfk: friendCache.me.id, usernamefk: friendCache.me.first_name, emailfk: friendCache.me.email }, function (datafacebookreal) {
                // On a transmis toutes les infos du facebooker nécessaires
                // alert(datafacebookreal);
            });
        });
    }
}
function onAuthResponseChange(response) {
    console.log('onAuthResponseChange', response);
}

function getMe(callback) {
    FB.api('/me', { fields: 'id,name,email,first_name,picture.width(20).height(20)' }, function (response) {
        if (!response.error) {
            friendCache.me = response;
            callback();
        } else {
            console.error('/me', response);
        }
    });
}

function renderWelcome(identifiant, nomnutterfbk) {
            $('#login').empty();
            var urlfacebookTemporary2 = "/FacebookNutter/partialfbk";
            $.get(urlfacebookTemporary2, { idnombre: identifiant, idnom: nomnutterfbk }, function (datacompte2) {
                $("#login").html(datacompte2);
                $("#photo").attr('src', friendCache.me.picture.data.url);
                // Pour l'animation du statut de connexion
                $('#imageconnected').bind('fade-cycle', function () {
                    $(this).fadeOut(1000, function () {
                        $(this).fadeIn(1000, function () {
                            $(this).trigger('fade-cycle');
                        });
                    });
                });
                $('#imageconnected').each(function (index, elem) {
                    setTimeout(function () {
                        $(elem).trigger('fade-cycle');
                    }, index * 250);
                });
            });
}