using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class HomeController : ApplicationRealController
    {
        public ActionResult Index()
        {
            ViewBag.Message = "Pauline, tu vas bientôt jouer à l'awalé !";

            return View();
        }

        public ActionResult About(string erreur)
        {
            ViewBag.Message = "Your app description page.";
            ViewBag.erreurJeu = erreur;
            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public string nbdevisiteurs()
        {
            string cherif = System.Web.HttpContext.Current.Application["numberNutters"] as string;
            return cherif;
        }

        public string diminue()
        {
            string cherif = System.Web.HttpContext.Current.Application["numberNutters"] as string;
            int cherifcool = Convert.ToInt32(cherif);
            cherifcool = cherifcool - 1;
            System.Web.HttpContext.Current.Application["numberNutters"] = cherifcool.ToString();
            return "OK";
        }
    }
}
