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
    public class Play2Controller : ApplicationRealController
    {
        //
        // GET: /Play2/

        bool enregistre4 = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;

        public ActionResult Index(int levelreachedgame, long n1, long n2, long n3, long b)
        {
            string valeurglobale;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
            }

            AWLLevelsContext context = new AWLLevelsContext();
            AWLLevels monniveau = context.LevelsTable.FirstOrDefault(u => u.Id == levelreachedgame);
            ViewBag.niveau = monniveau.levelniveau;
            ViewBag.leveltop = monniveau.topalealevel;
            ViewBag.agitation = monniveau.agitation;
            ViewBag.n1 = n1;
            ViewBag.n2 = n2;
            ViewBag.b = b;

            if (System.Web.HttpContext.Current.Session["nutterAnonymous"] != null)
            {
                ViewBag.sessionencours = System.Web.HttpContext.Current.Session["nutterAnonymous"];
                ViewBag.n3 = n3 + Convert.ToInt32(System.Web.HttpContext.Current.Session["nutterAnonymous"]);
            }
            else
            {
                ViewBag.n3 = n3;
            }

            // Stockage du niveau
            ViewBag.haha = levelreachedgame;

            return View();
        }

        public int truelevel(int ntruelevel)
        {
            // Retourne le niveau du jeu suivant
            return ntruelevel;
        }

        public int level(int nlevel)
        {
            // Mettre le niveau de nombre de hibous en cours dans le compte du joueur ici
            return nlevel;
        }

        public int level2(int nleveltop)
        {
            // Retourne la position de départ des hibous
            return nleveltop;
        }

        public int level3(int nlevelagite)
        {
            // Retourne la position de départ des hibous
            return nlevelagite;
        }

        public string gameend(int n1, int n2, int n3, int b, int good)
        {
            try
            {
                string valeurglobale;
                if (System.Web.HttpContext.Current.Session["idfbk"] != null)
                {
                    valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                    ViewBag.idfbk = valeurglobale;
                    if (!string.IsNullOrEmpty(valeurglobale))
                    {
                        // Si c'est un facebook user, on stocke les scores dans le modèle facebook
                        string idfacebooker = Convert.ToString(ViewBag.idfbk);
                        AWLFacebookContext db = new AWLFacebookContext();
                        AWLFacebookProfile user = db.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(valeurglobale));
                        user.UserNuts1 = n3;
                        user.UserNuts2 = n2;
                        user.UserNuts3 = n1;
                        user.UserBonus = b;
                        user.UserLevel = good;
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
                    if (enregistre4)
                    {
                        // Si c'est un nutter user, on stocke les scores dans le modèle du user courant
                        UsersContext db = new UsersContext();
                        UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(System.Web.HttpContext.Current.User.Identity.Name));
                        user.UserNuts1 = n3;
                        user.UserNuts2 = n2;
                        user.UserNuts3 = n1;
                        user.UserBonus = b;
                        user.UserLevel = good;
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
                    else
                    {
                        // On détruit la variable de session
                        if (System.Web.HttpContext.Current.Session["nutterAnonymous"] != null)
                        {
                            System.Web.HttpContext.Current.Session.Remove("nutterAnonymous");
                        }
                    }
                }

                // Retourne la position de départ des hibous
                return "OK";
            }
            catch(Exception ex)
            {
                return ex.ToString();
            }
        }
    }
}