using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using DotNetOpenAuth.AspNet;
using System.Diagnostics;
using CleverNuts.Models;

namespace CleverNuts.Controllers
{
    public class PlayController : ApplicationRealController
    {
        // Pour créer lors du start de l'application sur le web
        // la liste de toutes les parties qui seront jouées
        // Liste de parties du jeu
        private static List<CreatePartie> PartiesCln = new List<CreatePartie>();
        private static List<string> PartiesNames = new List<string>();

        bool enregistre = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
        static CreatePartie partie = new CreatePartie("Anonymous1", "Anonymous2");

        bool answer;
        string joueur1nom;
        string joueur2nom;
        string joueur1score;
        string joueur2score;
        string joueur1scorebonus;
        string joueur2scorebonus;
        int nombreEnligne;
        int adversaireId;
        List<string> loggedInUsers;
        string adversaire;
        
        // Pour stocker l'identifiant de la partie en cours
        static string idPartieHub = "";

        public ActionResult Index()
        {

            string valeurglobale;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
            }

            /*
            // Si c'est un nutter user
                    if(enregistre)
                    {
                // Pour trouver le nombre d'utilisateurs de la liste et extraire l'adversaire
     //           if (HttpRuntime.Cache["LoggedInUsers"] != null) //if the list exists, add this user to it
     //           {
                    //get the list of logged in users from the cache
     //               loggedInUsers = (List<string>)HttpRuntime.Cache["LoggedInUsers"];
      //              nombreEnligne = loggedInUsers.Count;
      //          }
                // Else Arrivera rarement, dans ce cas faire jouer contre l'ordinateur

                // Choisis un utilisateur au hasard en ligne
     //           adversaireId = RandomNumber(0, nombreEnligne-1);
    //            adversaire = loggedInUsers.ElementAt(adversaireId);

                // Création de la partie entre le user et un adversaire au hasard
    //            partie = new CreatePartie(System.Web.HttpContext.Current.User.Identity.Name, adversaire);
                // On ajoutera plus tard les parties users à la même liste de parties
                // Ou on en créera une autre
                    }

                // Si c'est un nutter anonymous
                    else
                    {
                        //partie = new CreatePartie("Anonymous1", "Anonymous2");
                    }
            //ViewBag.Message = "Pauline, tu vas bientôt jouer à l'awalé !"; */
            return View();
        }

        public string getNutterUser()
        {
            return System.Web.HttpContext.Current.User.Identity.Name;
        }

        public string getNutterUserFacebook()
        {
            string valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
            AWLFacebookContext contexte = new AWLFacebookContext();
            string usernamereal = contexte.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(valeurglobale)).UserName;
            return usernamereal;
        }

        // On modifie la partie après récupération des adversaires
        public void modifPartie(string j1, string j2, string partiename)
        {
            // On crée la bonne finale partie
            CreatePartie newpartie = new CreatePartie(j1, j2);
            // On stocke l'identifiant hub de la partie
            // idPartieHub = partiename;
            // On ajoute la partie et son identifiant aux listes statiques de parties et d'ids
            PartiesCln.Add(newpartie);
            PartiesNames.Add(partiename);
        }

        public string Sequence(string possible, string codepartiejeu)
        {
            //answer = ;
            if (PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).SequenceJeu(possible))
            {
                return "OK";
            }
            else
            {
                return "KO";
            }

            // Mettre le code à appeler à chaque fois
            // avec des paramètres peut être
        }

        public string nom1(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "Anonymous1";
            }
            else
            {
                joueur1nom = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player1.pseudo;
                return joueur1nom;
            }
        }
        public string nom2(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "Anonymous2";
            }
            else
            {
                joueur2nom = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player2.pseudo;
                return joueur2nom;
            }
        }

        public string score1(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur1score = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player1.score.ToString();
                return joueur1score;
            }
        }
        public string score2(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur2score = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player2.score.ToString();
                return joueur2score;
            }
        }

        public string scorebonus1(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur1scorebonus = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player1.scorebonus.ToString();
                return joueur1scorebonus;
            }
        }
        public string scorebonus2(string jouant, string codepartiejeu)
        {
            if (jouant == "KO")
            {
                return "0";
            }
            else
            {
                joueur2scorebonus = PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).player2.scorebonus.ToString();
                return joueur2scorebonus;
            }
        }

        public string bonArgument(string codepartiejeu)
        {
            return PartiesCln.ElementAt(PartiesNames.IndexOf(codepartiejeu)).FindArgument();
        }

        public string checkUserOrAnonymous()
        {
            bool enregistre2 = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
            string valeurglobale;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
                if (!string.IsNullOrEmpty(valeurglobale))
                {
                    return "facebook";
                }
                else
                {
                    return "anonym";
                }
            }
            else
            {
                if (!enregistre2)
                {
                    return "anonym";
                }
                else
                {
                    return "user";
                }
            }
        }
        
        public string EndGame(string idMoi, string position, int score1fin, int score2fin)
        {
            /*// Les scores sont là, il ne reste qu'à les mettre dans les VRAIS profils
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player1.score = score1fin;
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player2.score = score2fin;
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player1.scorebonus = score1fin * 100;
            PartiesCln.ElementAt(PartiesNames.IndexOf(idPartieHub)).player2.scorebonus = score2fin * 100;
            */
            string valeurglobale;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
                if (!string.IsNullOrEmpty(valeurglobale))
                {
                    // Si c'est un nutter facebook, on stocke les scores dans le modèle
                    AWLFacebookContext db = new AWLFacebookContext();
                    AWLFacebookProfile user = db.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(valeurglobale));
                    if (position == "1")
                    {
                        user.UserNuts1 = user.UserNuts1 + score1fin;
                        user.UserBonus = user.UserBonus + score1fin * 10;
                        // Mise à jour des noix d'or, de bronze et simples
                        while (user.UserNuts1 > 30)
                        {
                            int restesimple = user.UserNuts1 - 30;
                            user.UserNuts2 = user.UserNuts2 + 1;
                            user.UserNuts1 = restesimple;
                        }
                        while (user.UserNuts2 > 10)
                        {
                            int restesimple2 = user.UserNuts2 - 10;
                            user.UserNuts3 = user.UserNuts3 + 1;
                            user.UserNuts2 = restesimple2;
                        }
                        db.SaveChanges();
                        // Destruction de la partie par l'initiateur seul de la partie
                        int positionmoi = PartiesNames.IndexOf(idMoi);
                        PartiesCln.RemoveAt(positionmoi);
                        PartiesNames.RemoveAt(positionmoi);
                    }
                    else if (position == "2")
                    {
                        user.UserNuts1 = user.UserNuts1 + score2fin;
                        user.UserBonus = user.UserBonus + score2fin * 10;
                        // Mise à jour des noix d'or, de bronze et simples
                        while (user.UserNuts1 > 30)
                        {
                            int restesimple = user.UserNuts1 - 30;
                            user.UserNuts2 = user.UserNuts2 + 1;
                            user.UserNuts1 = restesimple;
                        }
                        while (user.UserNuts2 > 10)
                        {
                            int restesimple2 = user.UserNuts2 - 10;
                            user.UserNuts3 = user.UserNuts3 + 1;
                            user.UserNuts2 = restesimple2;
                        }
                        db.SaveChanges();
                    }
                }
            }
            else
            {
                if (enregistre)
                {
                    // Si c'est un nutter user, on stocke les scores dans le modèle du user courant
                    UsersContext db = new UsersContext();
                    UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(User.Identity.Name));
                    if (position == "1")
                    {
                        user.UserNuts1 = user.UserNuts1 + score1fin;
                        user.UserBonus = user.UserBonus + score1fin * 10;
                        // Mise à jour des noix d'or, de bronze et simples
                        while (user.UserNuts1 > 30)
                        {
                            int restesimple = user.UserNuts1 - 30;
                            user.UserNuts2 = user.UserNuts2 + 1;
                            user.UserNuts1 = restesimple;
                        }
                        while (user.UserNuts2 > 10)
                        {
                            int restesimple2 = user.UserNuts2 - 10;
                            user.UserNuts3 = user.UserNuts3 + 1;
                            user.UserNuts2 = restesimple2;
                        }
                        db.SaveChanges();
                        // Destruction de la partie par l'initiateur seul de la partie
                        int positionmoi = PartiesNames.IndexOf(idMoi);
                        PartiesCln.RemoveAt(positionmoi);
                        PartiesNames.RemoveAt(positionmoi);
                    }
                    else if (position == "2")
                    {
                        user.UserNuts1 = user.UserNuts1 + score2fin;
                        user.UserBonus = user.UserBonus + score2fin * 10;
                        // Mise à jour des noix d'or, de bronze et simples
                        while (user.UserNuts1 > 30)
                        {
                            int restesimple = user.UserNuts1 - 30;
                            user.UserNuts2 = user.UserNuts2 + 1;
                            user.UserNuts1 = restesimple;
                        }
                        while (user.UserNuts2 > 10)
                        {
                            int restesimple2 = user.UserNuts2 - 10;
                            user.UserNuts3 = user.UserNuts3 + 1;
                            user.UserNuts2 = restesimple2;
                        }
                        db.SaveChanges();
                    }

                }
                else
                {
                    // Création des variables de session pour les nutters anonymes et stockage des scores
                    if (position == "1")
                    {
                        if (System.Web.HttpContext.Current.Session["nutterAnonymous"] != null)
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = (int)System.Web.HttpContext.Current.Session["nutterAnonymous"] + score1fin;
                        }
                        else
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = score1fin;
                        }
                        // Destruction de la partie par l'initiateur seul de la partie
                        int positionmoi = PartiesNames.IndexOf(idMoi);
                        PartiesCln.RemoveAt(positionmoi);
                        PartiesNames.RemoveAt(positionmoi);
                    }
                    else if (position == "2")
                    {
                        if (System.Web.HttpContext.Current.Session["nutterAnonymous"] != null)
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = (int)System.Web.HttpContext.Current.Session["nutterAnonymous"] + score2fin;
                        }
                        else
                        {
                            System.Web.HttpContext.Current.Session["nutterAnonymous"] = score2fin;
                        }
                    }
                }
            }

            //System.Web.HttpContext.Current.User.Identity.Name
            return "Fin du jeu !";
        }

        private int RandomNumber(int min, int max)
        {
            Random random = new Random();
            return random.Next(min, max);
        }
        
        public int getmysession(string monid)
        {
            int resultatnoix = (int)System.Web.HttpContext.Current.Session[monid];
            return resultatnoix;
        }
    }
}