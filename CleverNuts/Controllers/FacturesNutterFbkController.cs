using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class FacturesNutterFbkController : ApplicationRealController
    {
        //
        // GET: /Factures/

        public ActionResult Index(string identnutter)
        {
            // Recherche du nutter
            AWLFacebookContext contextNuttersFacebook2 = new AWLFacebookContext();
            AWLFacebookProfile nutterDefacebookreel = contextNuttersFacebook2.FacebookNuttersTable.FirstOrDefault((o => o.UserId.Equals(identnutter)));
            
            // Split du buyer
            // Pour les achats d'avant effectués par le nutter
            AWLFacturesContext contextFactures = new AWLFacturesContext();
            List<AWLFacture> tablePaiementsNutters = contextFactures.FacturesTable.ToList();
            List<AWLFacture> vraiTableau = new List<AWLFacture>();

            for (int u = 0; u < tablePaiementsNutters.Count; u++)
            {
                if (tablePaiementsNutters.ElementAt(u).Buyer.Count(f => f == '/') >= 1)
                {
                    string[] split = tablePaiementsNutters.ElementAt(u).Buyer.Split('/');
                    int endroit = tablePaiementsNutters.ElementAt(u).Buyer.Count(f => f == '/');
                    if (split[endroit] == identnutter)
                    {
                        vraiTableau.Add(tablePaiementsNutters.ElementAt(u));
                    }
                }
            }

                // Transmission des listes des achats précédemment effectués
            ViewBag.resultat = vraiTableau;

            return View();
        }
    }
}