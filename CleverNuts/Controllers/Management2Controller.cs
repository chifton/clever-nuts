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
    public class Management2Controller : ApplicationRealController
    {
        //
        // GET: /Management2/
        bool enregistre3 = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;

        public ActionResult Index()
        {
            string valeurglobale = string.Empty; ;
            if (System.Web.HttpContext.Current.Session["idfbk"] != null)
            {
                valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                ViewBag.idfbk = valeurglobale;
            }


            if(valeurglobale != string.Empty)
            {
                // Appel vers la fonction Index de Play2
                AWLFacebookContext db = new AWLFacebookContext();
                AWLFacebookProfile user = db.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(valeurglobale));
                ViewBag.awlchamplevelniveau = 1;
                ViewBag.awlchamptopalealevel = 10;
                ViewBag.awlchampagitation = 1000;
                ViewBag.awlchampn1 = user.UserNuts3;
                ViewBag.awlchampn2 = user.UserNuts2;
                ViewBag.awlchampn3 = user.UserNuts1;
                ViewBag.awlchampb = user.UserBonus;


                // Récupération du niveau atteint quand on est enregistré
                ViewBag.levelreached = user.UserLevel;
            }
            else
            {
            if(enregistre3)
            {
                // Si c'est un nutter user, on stocke les scores dans le modèle du user courant
                UsersContext db = new UsersContext();
                UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(System.Web.HttpContext.Current.User.Identity.Name));
                ViewBag.awlchamplevelniveau = 1;
                ViewBag.awlchamptopalealevel = 10;
                ViewBag.awlchampagitation = 1000;
                ViewBag.awlchampn1 = user.UserNuts3;
                ViewBag.awlchampn2 = user.UserNuts2;
                ViewBag.awlchampn3 = user.UserNuts1;
                ViewBag.awlchampb = user.UserBonus;


                // Récupération du niveau atteint quand on est enregistré
                ViewBag.levelreached = user.UserLevel;
            }
            else {
                    ViewBag.awlchamplevelniveau = 1;
                    ViewBag.awlchamptopalealevel = 10;
                    ViewBag.awlchampagitation = 1000;
                    ViewBag.awlchampn1 = 0;
                    ViewBag.awlchampn2 = 0;
                    ViewBag.awlchampn3 = 10;
                    ViewBag.awlchampb = 0;

                // Niveau atteint quand on n'est pas enregistré
                ViewBag.levelreached = 1;
            }
        }

            return View();
        }

    }
}
