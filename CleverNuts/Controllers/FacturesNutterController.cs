using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class FacturesNutterController : ApplicationRealController
    {
        //
        // GET: /Factures/

        public ActionResult Index()
        {
            // Recherche du nutter
            UsersContext db = new UsersContext();
            UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(System.Web.HttpContext.Current.User.Identity.Name));
       
            // Pour les achats d'avant effectués par le nutter
            AWLFacturesContext contextFactures = new AWLFacturesContext();
            List<AWLFacture> tablePaiementsNutters = contextFactures.FacturesTable.Where(u => u.Buyer.Equals(user.UserName)).ToList();
            

            // Transmission des listes des achats précédemment effectués
            ViewBag.resultat = tablePaiementsNutters;

            return View();
        }
    }
}
