using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class BuyController : ApplicationRealController
    {
        //
        // GET: /Buy/

        public ActionResult Index(string choix)
        {
            // On récupère le choix d'achat du nutter
            ViewBag.monachat = choix;
            return View();
        }
    }
}